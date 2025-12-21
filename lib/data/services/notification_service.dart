import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uap_reusea/models/notification_model.dart';

class NotificationService {
  final String baseUrl = 'https://dummyjson.com/products';

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];

      return products
          .map((e) => NotificationModel.fromProductJson(e))
          .toList();
    } else {
      throw Exception('Gagal memuat notifikasi');
    }
  }
}
