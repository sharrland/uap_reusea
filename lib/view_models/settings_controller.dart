import 'package:get/get.dart';
import 'package:uap_reusea/routes/app_routes.dart';

class SettingsController extends GetxController {
  /// LOGOUT
  /// Karena DummyJSON tidak menyimpan session,
  /// logout cukup reset navigation ke halaman login
  void logout() {
    // Hapus seluruh route & kembali ke login
    Get.offAllNamed(AppRoutes.login);
  }
}
