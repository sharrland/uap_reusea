class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String category;
  final String time;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.time,
    this.isRead = false,
  });

  factory NotificationModel.fromProductJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['description'],
      category: json['availabilityStatus'] ?? 'Info Produk',
      time: json['meta']?['createdAt'] ?? '',
    );
  }
}
