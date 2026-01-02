import 'package:uap_reusea/models/chat_model.dart';

class ChatService {
  Future<List<ChatModel>> getChatList() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // ✅ Return 2 dummy chats from buyers who made offers
      return [
        ChatModel(
          id: 'chat_001',
          sellerId: 'buyer_001',
          sellerName: 'Sarah Johnson',
          sellerAvatar: 'https://i.pravatar.cc/150?img=5',
          lastMessage: 'Made an offer \$6.00',
          time: '10:30',
          unreadCount: 1,
          product: {
            'id': '1',
            'title': 'Essence Mascara Lash Princess',
            'price': 9.99,
            'thumbnail': 'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png',
          },
        ),
        ChatModel(
          id: 'chat_002',
          sellerId: 'buyer_002',
          sellerName: 'Michael Chen',
          sellerAvatar: 'https://i.pravatar.cc/150?img=12',
          lastMessage: 'Made an offer \$10.00',
          time: '09:15',
          unreadCount: 1,
          product: {
            'id': '2',
            'title': 'Powder Canister',
            'price': 14.99,
            'thumbnail': 'https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png',
          },
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load chat list: $e');
    }
  }

  // Get chat messages (empty by default)
  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return empty - messages will be added by user
    return [];
  }

  // Send message
  Future<void> sendMessage(String chatId, String message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In real app, this would send to backend
  }
}