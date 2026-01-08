import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:uap_reusea/routes/app_pages.dart';
import 'package:uap_reusea/routes/app_routes.dart';
import 'package:uap_reusea/views/navbar/bottom_navbar.dart';
import 'package:uap_reusea/view_models/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize UserController globally (permanent)
  Get.put(UserController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Reusea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB83556)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const BottomNavbar(),
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
