import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uap_reusea/models/user_model.dart';

class UserService {
  // Fetch random user dari Random User API
  Future<UserModel> fetchRandomUser() async {
    try {
      final response = await http.get(
        Uri.parse('https://randomuser.me/api/?results=1'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        
        if (results.isNotEmpty) {
          return UserModel.fromRandomUserApi(results[0]);
        }
      }
      
      // Fallback ke dummy jika API gagal
      return UserModel.dummy();
    } catch (e) {
      // Fallback ke dummy jika ada error
      return UserModel.dummy();
    }
  }

  // Fetch multiple users (jika butuh di masa depan)
  Future<List<UserModel>> fetchMultipleUsers(int count) async {
    try {
      final response = await http.get(
        Uri.parse('https://randomuser.me/api/?results=$count'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        
        return results
            .map((user) => UserModel.fromRandomUserApi(user))
            .toList();
      }
      
      return [UserModel.dummy()];
    } catch (e) {
      return [UserModel.dummy()];
    }
  }
}