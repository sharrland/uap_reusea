import 'package:uap_reusea/models/chat_model.dart';
import 'package:uap_reusea/data/services/chat_service.dart';

class ChatRepository {
  final ChatService _service = ChatService();

  // Get all chats
  Future<List<ChatModel>> getChats() async {
    try {
      return await _service.getChatList();
    } catch (e) {
      throw Exception('Failed to get chats: $e');
    }
  }

  // Get messages for specific chat
  Future<List<ChatMessageModel>> getChatMessages(String chatId) async {
    try {
      return await _service.getChatMessages(chatId);
    } catch (e) {
      throw Exception('Failed to get chat messages: $e');
    }
  }

  // Send message
  Future<void> sendMessage(String chatId, String message) async {
    try {
      await _service.sendMessage(chatId, message);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}