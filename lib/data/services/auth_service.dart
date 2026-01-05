import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://dummyjson.com";

  /// LOGIN ke DummyJSON
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "expiresInMins": 30,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return {"error": "Login failed", "statusCode": response.statusCode};
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  /// REGISTER (SIMULASI / DUMMY)
  Future<Map<String, dynamic>> register(
    String username,
    String password,
  ) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (username.isNotEmpty && password.length >= 6) {
        return {
          "token": "mock_token_${DateTime.now().millisecondsSinceEpoch}",
          "email": "$username@example.com",
          "username": username,
        };
      }

      return {"error": "Username dan password minimal 6 karakter"};
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
