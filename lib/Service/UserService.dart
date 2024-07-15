import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class UserService {
  static const String API_URL = 'http://10.50.100.26:8081';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<UserRaDto> getCurrentUser() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('Aucun token d\'authentification trouvé');
    }

    final response = await http.get(
      Uri.parse('$API_URL/api/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserRaDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement du profil utilisateur: ${response.statusCode}');
    }
  }


  Future<UserRaDto> updateCurrentUser(UserRaDto updatedUser) async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      throw Exception('Aucun token d\'authentification trouvé');
    }

    final response = await http.put(
      Uri.parse('$API_URL/api/updateme'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(updatedUser.toJson()),
    );

    if (response.statusCode == 200) {
      return UserRaDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du profil utilisateur: ${response.statusCode}');
    }
  }


}