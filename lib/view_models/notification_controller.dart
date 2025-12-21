import 'package:get/get.dart';
import 'package:uap_reusea/models/notification_model.dart';
import 'package:uap_reusea/data/repositories/notification_repository.dart';
import 'package:uap_reusea/data/services/notification_service.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  late NotificationRepository repository;

  @override
  void onInit() {
    super.onInit();
    repository = NotificationRepository(NotificationService());
    loadNotifications();
  }

  void loadNotifications() async {
    try {
      isLoading.value = true;
      final result = await repository.getNotifications();
      notifications.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
