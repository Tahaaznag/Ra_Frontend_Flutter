import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.50.100.6:8081';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/authenticate'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        await _storeToken(token);
        return true;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred during login: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name, String prenom, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'name': name,
          'prenom': prenom,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 202) {
        return true;
      } else {
        print('Registration failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('An error occurred during registration: $e');
      return false;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null;
  }

  Future<void> logout() async {
    await _removeToken();
  }

  // Private methods for token management
  Future<void> _storeToken(String token) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  Future<void> _removeToken() async {
    await _secureStorage.delete(key: 'jwt_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}