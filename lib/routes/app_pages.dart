import 'package:get/get.dart';
import 'package:uap_reusea/views/settings/settings_view.dart';
import 'package:uap_reusea/views/profile/edit_profile_view.dart';
import 'package:uap_reusea/views/settings/change_password_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: '/settings',
      page: () => const SettingsView(),
    ),
    GetPage(
      name: '/edit-profile',
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: '/change-password',
      page: () => const ChangePasswordView(),
    ),
  ];
}
