import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Semua field wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading = true;
    notifyListeners();

    // SIMULASI PROSES REGISTER
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    Get.snackbar(
      'Berhasil',
      'Registrasi berhasil, silakan login',
      snackPosition: SnackPosition.BOTTOM,
    );

    return true;
  }
}
