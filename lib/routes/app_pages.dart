import 'package:get/get.dart';
import 'package:uap_reusea/views/auth/login_view.dart';
import 'package:uap_reusea/views/auth/register_view.dart';
import 'package:uap_reusea/views/navbar/bottom_navbar.dart';
import 'package:uap_reusea/views/settings/settings_view.dart';
import 'package:uap_reusea/views/profile/edit_profile_view.dart';
import 'package:uap_reusea/views/settings/change_password_view.dart';
import 'package:uap_reusea/views/home/product_detail_view.dart';
import 'package:uap_reusea/views/home/make_offer_view.dart';
import 'package:uap_reusea/views/chat/chat_room_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginView()),
    GetPage(name: AppRoutes.register, page: () => RegisterView()),
    GetPage(name: AppRoutes.home, page: () => const BottomNavbar()),

    // Existing routes
    GetPage(name: '/settings', page: () => const SettingsView()),
    GetPage(name: '/edit-profile', page: () => const EditProfileView()),
    GetPage(name: '/change-password', page: () => const ChangePasswordView()),

    // New routes for your part
    GetPage(
      name: '/product-detail',
      page: () => const ProductDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/make-offer',
      page: () => const MakeOfferView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/chat-room',
      page: () => const ChatRoomView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
