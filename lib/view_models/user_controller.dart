import 'package:get/get.dart';
import 'package:uap_reusea/models/user_model.dart';
import 'package:uap_reusea/data/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _repository = UserRepository();

  // Observable current user
  final currentUser = Rx<UserModel?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  // Fetch current user from Random User API
  Future<void> fetchCurrentUser() async {
    try {
      isLoading.value = true;
      final user = await _repository.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      // Fallback ke dummy
      currentUser.value = UserModel.dummy();
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh user (jika mau ganti user baru)
  Future<void> refreshUser() async {
    await fetchCurrentUser();
  }

  // Get user data (helper)
  String get username => currentUser.value?.username ?? '@user';
  String get fullName => currentUser.value?.fullName ?? 'User';
  String get avatar => currentUser.value?.avatar ?? 'https://i.pravatar.cc/300';
  String get email => currentUser.value?.email ?? '';
  String get phone => currentUser.value?.phone ?? '';
}