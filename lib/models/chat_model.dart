class ChatModel {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerAvatar;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final dynamic product; // Ubah dari ProductModel ke dynamic untuk avoid circular import

  ChatModel({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerAvatar,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.product,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id']?.toString() ?? '',
      sellerId: json['sellerId']?.toString() ?? '',
      sellerName: json['sellerName'] ?? 'Unknown Seller',
      sellerAvatar: json['sellerAvatar'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      product: json['product'], // Simpan sebagai dynamic
    );
  }
}

class ChatMessageModel {
  final String id;
  final String message;
  final String time;
  final bool isSender;
  final String? imageUrl;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.time,
    required this.isSender,
    this.imageUrl,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      isSender: json['isSender'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }
}