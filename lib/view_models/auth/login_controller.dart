import 'package:flutter/material.dart';
import 'package:uap_reusea/data/repositories/auth_repository.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.login(username, password);

      if (user == null) {
        errorMessage = "Login gagal. Username atau password salah.";
        return false;
      }

      return true;
    } catch (e) {
      errorMessage = "Terjadi kesalahan. Silakan coba lagi.";
      // ignore: avoid_print
      print("Login error (Controller): $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
