import 'package:uap_reusea/models/notification_model.dart';
import 'package:uap_reusea/data/services/notification_service.dart';

class NotificationRepository {
  final NotificationService service;

  NotificationRepository(this.service);

  Future<List<NotificationModel>> getNotifications() {
    return service.fetchNotifications();
  }
}