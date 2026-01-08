import 'package:uap_reusea/models/user_model.dart';
import 'package:uap_reusea/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  /// LOGIN (DummyJSON)
  Future<UserModel?> login(String username, String password) async {
    try {
      final result = await _service.login(username, password);

      if (result.containsKey('accessToken')) {
        return UserModel.fromDummyJson(result);
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print("Login error (Repository): $e");
      return null;
    }
  }

  /// REGISTER (SIMULASI)
 Future<UserModel?> register(String username, String password) async {
  try {
    final result = await _service.register(username, password);

    if (result.containsKey('token')) {
      return UserModel.fromRegisterDummy(
        result,                  
        result['email'],          
        username,                 
      );
    }

    // ignore: avoid_print
    print("Register failed (Repository): $result");
    return null;
  } catch (e) {
    // ignore: avoid_print
    print("Register error (Repository): $e");
    return null;
  }
}
}
