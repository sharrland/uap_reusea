import 'package:get/get.dart';
import 'package:uap_reusea/view_models/notification_controller.dart';

class NavbarController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final NotificationController notificationController =
    Get.put(NotificationController(), permanent: true);

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
