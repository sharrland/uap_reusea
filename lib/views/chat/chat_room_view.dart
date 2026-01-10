import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/models/chat_model.dart';
import 'package:uap_reusea/view_models/chat_controller.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _messageController = TextEditingController();
  late ChatController _chatController;
  String _chatId = '';
  String _productId = '';

  @override
  void initState() {
    super.initState();
    _chatController = Get.put(ChatController());
    
    final chat = Get.arguments as ChatModel?;
    if (chat != null) {
      _chatId = chat.id;
      final product = chat.product;
      if (product != null) {
        _productId = product is Map 
            ? product['id']?.toString() ?? '' 
            : product.id?.toString() ?? '';
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showMakeOfferSheet(ChatModel chat) {
    final offerController = TextEditingController();
    String? errorMessage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Make an Offer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (chat.product != null) ...[
                    Builder(
                      builder: (context) {
                        final product = chat.product;
                        final dynamic priceValue = product is Map 
                            ? product['price']
                            : product.price;
                        final double price = (priceValue as num).toDouble();
                        
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Seller Price:', style: TextStyle(fontSize: 14, fontFamily: 'Inter')),
                              Text(
                                '\$${price.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text('Your Offer', style: TextStyle(fontSize: 14, fontFamily: 'Inter', color: Colors.black54)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: offerController,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      hintText: '0.00',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onChanged: (value) {
                      if (errorMessage != null) {
                        setModalState(() {
                          errorMessage = null;
                        });
                      }
                    },
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13, fontFamily: 'Inter')),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final offerText = offerController.text.replaceAll(',', '');
                        final offer = double.tryParse(offerText);
                        
                        if (offer == null || offer <= 0) {
                          setModalState(() {
                            errorMessage = 'Please enter valid amount';
                          });
                          return;
                        }
                        
                        final product = chat.product;
                        final dynamic priceValue = product is Map 
                            ? product['price']
                            : product.price;
                        final double originalPrice = (priceValue as num).toDouble();
                        final double minPrice = originalPrice * 0.8;
                        
                      if (offer < minPrice) {
                          final errorText = 'Your offer is too low. Minimum offer is \$${minPrice.toStringAsFixed(2)} (80% of original price)';
                          setModalState(() {
                            errorMessage = errorText;
                          });
                          return;
                        }
                        
                        final nav = Navigator.of(context);
                        await _chatController.makeOffer(_chatId, _productId, offer);
                        
                        if (mounted) {
                          setState(() {});
                          nav.pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB83556),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        elevation: 0,
                      ),
                      child: const Text('Make Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter', color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCancelOfferDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text('Cancel Offer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
        content: const Text('Are you sure you want to cancel your offer?', style: TextStyle(fontSize: 15, fontFamily: 'Inter')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO', style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
          ),
          TextButton(
            onPressed: () async {
              final nav = Navigator.of(context);
              await _chatController.cancelOffer(_chatId, _productId);
              
              if (mounted) {
                setState(() {});
                nav.pop();
              }
            },
            child: const Text('YES', style: TextStyle(color: Color(0xFFB83556), fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatModel chat = Get.arguments as ChatModel;

    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      appBar: _buildAppBar(chat),
      body: Column(
        children: [
          if (chat.product != null) _buildProductInfo(chat.product!),
          Obx(() {
            final hasActiveOffer = _chatController.hasActiveOffer(_chatId, _productId);
            return _buildActionButtons(chat, hasActiveOffer);
          }),
          Expanded(
            child: Obx(() {
              final offerHistory = _chatController.getOfferHistory(_chatId, _productId);
              final messages = _chatController.getChatMessages(_chatId);
              
              if (offerHistory.isEmpty && messages.isEmpty) {
                return _buildEmptyChat();
              }
              
              return _buildChatMessages(offerHistory, messages);
            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatModel chat) {
    return AppBar(
      backgroundColor: const Color(0xFFFFEBEE),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            chat.sellerName,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            'Online',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(dynamic product) {
    final dynamic titleValue = product is Map ? product['title'] : product.title;
    final String title = titleValue.toString();
    
    final dynamic priceValue = product is Map ? product['price'] : product.price;
    final double price = (priceValue as num).toDouble();
    
    final dynamic thumbnailValue = product is Map ? product['thumbnail'] : product.thumbnail;
    final String thumbnail = thumbnailValue.toString();

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              thumbnail,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey.shade100,
                  child: Icon(Icons.image, color: Colors.grey.shade400, size: 24),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 3),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Inter', color: Color(0xFFB83556)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ChatModel chat, bool hasActiveOffer) {
    // Check if this is a buyer's offer (seller can't cancel it)
    final offerHistory = _chatController.getOfferHistory(_chatId, _productId);
    final isBuyerOffer = offerHistory.isNotEmpty && 
                         (offerHistory.last['isBuyerOffer'] as bool? ?? false);
    
    // Don't show Cancel Offer button if it's a buyer's offer
    if (hasActiveOffer && isBuyerOffer) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (hasActiveOffer) {
              _showCancelOfferDialog();
            } else {
              _showMakeOfferSheet(chat);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: hasActiveOffer ? Colors.grey.shade400 : const Color(0xFFB83556),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 0,
          ),
          child: Text(
            hasActiveOffer ? 'Cancel Offer' : 'Make Offer',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter', color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No messages yet', style: TextStyle(fontSize: 16, fontFamily: 'Inter', color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildChatMessages(List<Map<String, dynamic>> offerHistory, List<Map<String, dynamic>> messages) {
    final List<Map<String, dynamic>> allItems = [];
    
    for (var offer in offerHistory) {
      allItems.add({
        'type': 'offer',
        'data': offer,
        'timestamp': DateTime.parse(offer['timestamp'] as String).millisecondsSinceEpoch,
      });
    }
    
    for (var msg in messages) {
      allItems.add({
        'type': 'message',
        'data': msg,
        'timestamp': msg['timestamp'] as int,
      });
    }
    
    allItems.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        final type = item['type'] as String;
        final data = item['data'] as Map<String, dynamic>;
        
        if (type == 'offer') {
          final offerData = data;
          final status = offerData['status'] as String;
          final isCancelled = status == 'cancelled';
          final isBuyerOffer = offerData['isBuyerOffer'] as bool? ?? false;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: isBuyerOffer ? MainAxisAlignment.start : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isBuyerOffer) ...[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      color: const Color(0xFFB83556),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isBuyerOffer ? Colors.white : const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(8),
                    border: isBuyerOffer ? Border.all(color: Colors.grey.shade200) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCancelled ? 'Cancelled Offer' : 'Made An Offer',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          decoration: isCancelled ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${(offerData['amount'] as double).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: isCancelled ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isBuyerOffer) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      color: const Color(0xFFB83556),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                ],
              ],
            ),
          );
        } else {
          final isSender = data['isSender'] as bool;
          final message = data['message'] as String;
          final time = data['time'] as String;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isSender) ...[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      color: const Color(0xFFB83556),
                    ),
                    child: const Icon(Icons.storefront, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Column(
                    crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                        decoration: BoxDecoration(
                          color: isSender ? const Color(0xFFD9D9D9) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isSender ? 18 : 4),
                            bottomRight: Radius.circular(isSender ? 4 : 18),
                          ),
                          border: isSender ? null : Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSender ? Colors.black : Colors.black87,
                            fontFamily: 'Inter',
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          time,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontFamily: 'Inter'),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSender) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      color: const Color(0xFFB83556),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                ],
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(color: Color(0xFFB83556), shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {
                  final message = _messageController.text.trim();
                  if (message.isNotEmpty) {
                    _chatController.addMessage(_chatId, message, true);
                    _messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}