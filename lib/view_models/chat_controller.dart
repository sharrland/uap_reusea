import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/models/chat_model.dart';
import 'package:uap_reusea/data/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = ChatRepository();

  // Observable variables
  final chats = <ChatModel>[].obs;
  final messages = <ChatMessageModel>[].obs;
  final isLoading = false.obs;
  final isSendingMessage = false.obs;

  // Current chat
  final currentChat = Rx<ChatModel?>(null);

  // Text controller for message input
  final messageController = TextEditingController();

  // Offer tracking per chat/product
  final RxMap<String, Map<String, dynamic>> offers = <String, Map<String, dynamic>>{}.obs;
  
  // Message tracking per chat
  final RxMap<String, List<Map<String, dynamic>>> chatMessages = <String, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
    _loadDummyOffers();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  // Load dummy offers from buyers
  void _loadDummyOffers() {
    // Offer 1: Sarah Johnson - Essence Mascara (BUYER makes offer to SELLER)
    final key1 = _getOfferKey('chat_001', '1');
    offers[key1] = {
      'history': [
        {
          'amount': 6.00,
          'status': 'active',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
          'isBuyerOffer': true,
        }
      ],
      'currentOffer': 6.00,
    };
    
    // Add dummy messages for Sarah Johnson (buyer already chatted and made offer)
    chatMessages['chat_001'] = [
      {
        'message': 'Hi! Is this still available?',
        'time': '08:15',
        'isSender': false, // From buyer (Sarah)
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)).millisecondsSinceEpoch,
      },
    ];
    
    // Offer 2: Michael Chen - Powder Canister (BUYER makes offer to SELLER)
    final key2 = _getOfferKey('chat_002', '2');
    offers[key2] = {
      'history': [
        {
          'amount': 10.00,
          'status': 'active',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
          'isBuyerOffer': true,
        }
      ],
      'currentOffer': 10.00,
    };
    
    // Add dummy messages for Michael Chen (buyer already chatted and made offer)
    chatMessages['chat_002'] = [
      {
        'message': 'Hello, interested in this item. Can we negotiate the price?',
        'time': '07:30',
        'isSender': false, // From buyer (Michael)
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)).millisecondsSinceEpoch,
      },
    ];
  }

  // Fetch all chats
  Future<void> fetchChats() async {
    try {
      isLoading.value = true;
      final result = await _repository.getChats();
      chats.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load chats: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch messages for specific chat
  Future<void> fetchMessages(String chatId) async {
    try {
      isLoading.value = true;
      final result = await _repository.getChatMessages(chatId);
      messages.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load messages: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Open chat room
  void openChatRoom(ChatModel chat) {
    currentChat.value = chat;
    fetchMessages(chat.id);
  }

  // Add message to chat
  void addMessage(String chatId, String message, bool isSender) {
    if (chatMessages[chatId] == null) {
      chatMessages[chatId] = [];
    }
    
    final newMessage = {
      'message': message,
      'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'isSender': isSender,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    chatMessages[chatId]!.add(newMessage);
    chatMessages.refresh();
    
    // Update last message in chat list
    _updateChatWithMessage(chatId, message);
    
    // Trigger auto reply based on who sent the message
    final offerHistory = getOfferHistory(chatId, _getProductIdFromChat(chatId));
    final isBuyerOffer = offerHistory.isNotEmpty && 
                         (offerHistory.last['isBuyerOffer'] as bool? ?? false);
    
    if (isSender) {
      // User sent message - get reply from the other party
      _triggerAutoReply(chatId, message, isBuyerOffer);
    }
  }

  // Helper: Get product ID from chat (simplified)
  String _getProductIdFromChat(String chatId) {
    if (chatId == 'chat_001') return '1';
    if (chatId == 'chat_002') return '2';
    return '';
  }

  // Smart auto reply based on keywords and role
  void _triggerAutoReply(String chatId, String userMessage, bool isBuyerOffer) {
    Future.delayed(const Duration(seconds: 2), () {
      final reply = _getSmartReply(userMessage, isBuyerOffer);
      addMessage(chatId, reply, false);
    });
  }

  // Get smart reply based on message content and role
  String _getSmartReply(String message, bool isBuyerOffer) {
    final lowerMessage = message.toLowerCase();
    
    if (isBuyerOffer) {
      // Buyer made offer - BUYER replies (because seller sends message to buyer)
      return _getBuyerReply(lowerMessage);
    } else {
      // Seller made offer - SELLER replies
      return _getSellerReply(lowerMessage);
    }
  }

  // Seller's smart replies (when buyer made offer to seller)
  String _getSellerReply(String lowerMessage) {
    if (lowerMessage.contains('available') || lowerMessage.contains('still')) {
      return 'Yes, it\'s still available!';
    } else if (lowerMessage.contains('accept') || lowerMessage.contains('deal')) {
      return 'Great! When would you like to arrange pickup/delivery?';
    } else if (lowerMessage.contains('meet') || lowerMessage.contains('pickup')) {
      return 'We can arrange a meetup. Where would be convenient for you?';
    } else if (lowerMessage.contains('condition') || lowerMessage.contains('quality')) {
      return 'The item is in excellent condition! I can send more photos if you\'d like.';
    } else if (lowerMessage.contains('ship') || lowerMessage.contains('delivery')) {
      return 'Yes, I can ship it! Shipping costs depend on your location.';
    } else if (lowerMessage.contains('photo') || lowerMessage.contains('picture')) {
      return 'Sure! I can send you more photos. What angle would you like to see?';
    } else if (lowerMessage.contains('lower') || lowerMessage.contains('discount') || lowerMessage.contains('negotiate')) {
      return 'The price is negotiable. Feel free to make an offer!';
    } else if (lowerMessage.contains('payment') || lowerMessage.contains('pay')) {
      return 'I accept cash, bank transfer, or e-wallet. What works best for you?';
    } else {
      return _getSellerAutoResponse();
    }
  }

  // Buyer's smart replies (when seller offers or buyer asks questions)
  String _getBuyerReply(String lowerMessage) {
    if (lowerMessage.contains('available') || lowerMessage.contains('still')) {
      return 'Yes, I\'m still interested!';
    } else if (lowerMessage.contains('price') || lowerMessage.contains('offer')) {
      return 'Is the price negotiable? I\'d like to make an offer.';
    } else if (lowerMessage.contains('meet') || lowerMessage.contains('pickup')) {
      return 'I can pick it up this weekend. Where are you located?';
    } else if (lowerMessage.contains('condition') || lowerMessage.contains('quality')) {
      return 'Can you send more photos? I want to see the condition.';
    } else if (lowerMessage.contains('ship') || lowerMessage.contains('delivery')) {
      return 'Do you offer shipping? How much would it cost?';
    } else if (lowerMessage.contains('accept') || lowerMessage.contains('deal')) {
      return 'Perfect! How should we arrange the payment and pickup?';
    } else if (lowerMessage.contains('payment') || lowerMessage.contains('pay')) {
      return 'What payment methods do you accept?';
    } else if (lowerMessage.contains('discount') || lowerMessage.contains('lower')) {
      return 'Can you go any lower on the price?';
    } else {
      return _getBuyerAutoResponse();
    }
  }

  // Seller default responses
  String _getSellerAutoResponse() {
    final responses = [
      'Thank you for your interest!',
      'Let me know if you have any questions.',
      'Feel free to make an offer!',
      'I\'m happy to provide more details.',
      'The item is in great condition!',
    ];
    return responses[DateTime.now().second % responses.length];
  }

  // Buyer default responses
  String _getBuyerAutoResponse() {
    final responses = [
      'Thank you for the info!',
      'Let me think about it.',
      'That sounds reasonable.',
      'I\'m interested! Can we discuss further?',
      'When can I pick it up?',
    ];
    return responses[DateTime.now().second % responses.length];
  }

  // Get messages for a chat
  List<Map<String, dynamic>> getChatMessages(String chatId) {
    return chatMessages[chatId] ?? [];
  }

  // Send message
  Future<void> sendMessage() async {
    final message = messageController.text.trim();
    
    if (message.isEmpty || currentChat.value == null) return;

    try {
      isSendingMessage.value = true;

      // Add message to list immediately (optimistic update)
      final newMessage = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        time: _formatTime(DateTime.now()),
        isSender: true,
      );
      messages.add(newMessage);

      // Clear input
      messageController.clear();

      // Send to backend
      await _repository.sendMessage(currentChat.value!.id, message);

      // Simulate seller response after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        final response = ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: _getAutoResponse(),
          time: _formatTime(DateTime.now()),
          isSender: false,
        );
        messages.add(response);
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      // Remove the optimistic message if failed
      messages.removeLast();
    } finally {
      isSendingMessage.value = false;
    }
  }

  // Make an offer
  Future<void> makeOffer(String chatId, String productId, double amount) async {
    try {
      final key = _getOfferKey(chatId, productId);
      
      // Save offer with history
      if (offers[key] == null) {
        offers[key] = {
          'history': [],
          'currentOffer': null,
        };
      }

      // Add to history
      final offerData = {
        'amount': amount,
        'status': 'active',
        'timestamp': DateTime.now().toIso8601String(),
        'isBuyerOffer': false,
      };
      
      (offers[key]!['history'] as List).add(offerData);
      offers[key]!['currentOffer'] = amount;

      // Update chat if exists
      _addOrUpdateChat(chatId, productId, amount);

      Get.snackbar(
        'Success',
        'Offer sent successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB83556),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to make offer: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Cancel offer
  Future<void> cancelOffer(String chatId, String productId) async {
    try {
      final key = _getOfferKey(chatId, productId);
      
      if (offers[key] != null && offers[key]!['currentOffer'] != null) {
        final amount = offers[key]!['currentOffer'];
        
        // Update the last active offer to cancelled
        final history = offers[key]!['history'] as List;
        for (var i = history.length - 1; i >= 0; i--) {
          if (history[i]['status'] == 'active' && history[i]['amount'] == amount) {
            history[i]['status'] = 'cancelled';
            history[i]['cancelledAt'] = DateTime.now().toIso8601String();
            break;
          }
        }
        
        offers[key]!['currentOffer'] = null;

        // Update chat list
        _updateChatWithCancelledOffer(chatId);

        Get.snackbar(
          'Success',
          'Offer cancelled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel offer: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Get offer data for a chat/product
  Map<String, dynamic>? getOfferData(String chatId, String productId) {
    final key = _getOfferKey(chatId, productId);
    return offers[key];
  }

  // Check if there's an active offer
  bool hasActiveOffer(String chatId, String productId) {
    final key = _getOfferKey(chatId, productId);
    return offers[key]?['currentOffer'] != null;
  }

  // Get current offer amount
  double? getCurrentOffer(String chatId, String productId) {
    final key = _getOfferKey(chatId, productId);
    return offers[key]?['currentOffer'];
  }

  // Get offer history
  List<Map<String, dynamic>> getOfferHistory(String chatId, String productId) {
    final key = _getOfferKey(chatId, productId);
    if (offers[key] == null) return [];
    return List<Map<String, dynamic>>.from(offers[key]!['history'] ?? []);
  }

  // Helper: Generate unique key for offer
  String _getOfferKey(String chatId, String productId) {
    return '${chatId}_$productId';
  }

  // Helper: Add or update chat in list (no duplicates)
  void _addOrUpdateChat(String chatId, String productId, double amount) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    
    if (chatIndex == -1) {
      // Chat doesn't exist, DON'T add it here
      // It should only be added when user actually enters the chat room
      return;
    } else {
      // Update existing chat
      _updateChatWithOffer(chatId, amount);
    }
  }

  // Helper: Update chat list with new offer
  void _updateChatWithOffer(String chatId, double amount) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      final chat = chats[chatIndex];
      final updatedChat = ChatModel(
        id: chat.id,
        sellerId: chat.sellerId,
        sellerName: chat.sellerName,
        sellerAvatar: chat.sellerAvatar,
        lastMessage: 'Made an offer \$${amount.toStringAsFixed(2)}',
        time: 'Now',
        unreadCount: chat.unreadCount,
        product: chat.product,
      );
      chats[chatIndex] = updatedChat;
    }
  }

  // Helper: Update chat list with new message
  void _updateChatWithMessage(String chatId, String message) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      final chat = chats[chatIndex];
      final updatedChat = ChatModel(
        id: chat.id,
        sellerId: chat.sellerId,
        sellerName: chat.sellerName,
        sellerAvatar: chat.sellerAvatar,
        lastMessage: message,
        time: 'Now',
        unreadCount: chat.unreadCount,
        product: chat.product,
      );
      chats[chatIndex] = updatedChat;
    }
  }

  // Helper: Update chat list when offer cancelled
  void _updateChatWithCancelledOffer(String chatId) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      final chat = chats[chatIndex];
      final updatedChat = ChatModel(
        id: chat.id,
        sellerId: chat.sellerId,
        sellerName: chat.sellerName,
        sellerAvatar: chat.sellerAvatar,
        lastMessage: 'Cancelled Offer',
        time: 'Now',
        unreadCount: chat.unreadCount,
        product: chat.product,
      );
      chats[chatIndex] = updatedChat;
    }
  }

  // Helper: Format time
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper: Get auto response (kept for backward compatibility)
  String _getAutoResponse() {
    final responses = [
      'Thank you for your message!',
      'Let me check and get back to you.',
      'That sounds good!',
      'I\'m interested. Can we discuss further?',
      'Sure, when would be convenient for you?',
    ];
    return responses[DateTime.now().second % responses.length];
  }

  // Refresh chats
  Future<void> refreshChats() async {
    await fetchChats();
  }
}
