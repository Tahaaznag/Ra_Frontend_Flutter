import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remote_assist/Dtos/UserRaDto.dart';

class UserService {
  static const String API_URL = 'http://192.168.1.107:8081';

  Future<UserRaDto> getCurrentUser() async {
    final response = await http.get(Uri.parse('$API_URL/api/profile'));
    if (response.statusCode == 200) {
      return UserRaDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement du profil utilisateur');
    }
  }

  Future<UserRaDto> updateUser(UserRaDto user) async {
    final response = await http.put(
      Uri.parse('$API_URL/api/profile'),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserRaDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la mise à jour du profil utilisateur');
    }
  }
}