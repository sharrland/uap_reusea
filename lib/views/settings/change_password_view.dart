import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Get.snackbar(
                'Success',
                'Password updated successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
              Future.delayed(const Duration(milliseconds: 300), () {
              Get.offNamed('/settings');
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),

            _passwordField(hint: 'password'),
            const SizedBox(height: 16),
            _passwordField(hint: 'new password'),
            const SizedBox(height: 16),
            _passwordField(hint: 'A new password, again'),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({required String hint}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),
      ),
    ),
  );
}

}
