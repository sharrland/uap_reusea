import 'package:uap_reusea/models/user_model.dart';
import 'package:uap_reusea/data/services/user_service.dart';

class UserRepository {
  final UserService _service = UserService();

  // Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      return await _service.fetchRandomUser();
    } catch (e) {
      // Return dummy user jika gagal
      return UserModel.dummy();
    }
  }

  // Get multiple users (untuk keperluan lain)
  Future<List<UserModel>> getUsers(int count) async {
    try {
      return await _service.fetchMultipleUsers(count);
    } catch (e) {
      return [UserModel.dummy()];
    }
  }
}