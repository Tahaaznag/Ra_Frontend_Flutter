import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl = 'http://10.50.100.6:8081';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Non authentifié');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/user/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec de récupération des informations utilisateur');
    }
  }

  Future<bool> updateUserInfo(Map<String, dynamic> userInfo) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Non authentifié');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/api/user/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(userInfo),
    );

    return response.statusCode == 200;
  }
}