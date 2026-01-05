import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uap_reusea/view_models/auth/register_controller.dart';
import 'package:uap_reusea/routes/app_routes.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterController(),
      child: Consumer<RegisterController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: Stack(
              children: [
                /// BACKGROUND
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg_logindanregister.jpeg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// CONTENT
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),

                        /// BACK BUTTON
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xFFE91E63),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        _inputCard(label: "Name", controller: name),
                        const SizedBox(height: 18),
                        _inputCard(label: "Email", controller: email),
                        const SizedBox(height: 18),
                        _inputCard(
                          label: "Password",
                          controller: password,
                          obscure: true,
                        ),

                        const Spacer(),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () async {
                                    final success = await controller.register(
                                      name: name.text,
                                      email: email.text,
                                      password: password.text,
                                    );

                                    if (success) {
                                      Get.offNamed(AppRoutes.login);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC2185B),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: controller.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _inputCard({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
