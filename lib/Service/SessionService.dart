import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:remote_assist/Dtos/SessioRaDto.dart';

class SessionService {
  static const String baseUrl = 'http://10.50.100.26:8081';
  static const String sessionEndpoint = '/api/session';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<SessionRaDto> createSession(SessionRaDto sessionDto) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Aucun token d\'authentification trouvé');
    }

    final response = await http.post(
      Uri.parse('$baseUrl$sessionEndpoint/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sessionDto.toJson()),
    );

    if (response.statusCode == 201) {
      return SessionRaDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create session');
    }
  }

  Future<SessionRaDto> joinSession(String roomCode) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Aucun token d\'authentification trouvé');
    }

    final response = await http.post(
      Uri.parse('$baseUrl$sessionEndpoint/join?roomCode=$roomCode'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return SessionRaDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to join session');
    }
  }
  Future<List<SessionRaDto>> getSessionsByUser() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Aucun token d\'authentification trouvé');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$sessionEndpoint/mysessions'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => SessionRaDto.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch sessions');
    }
  }
}
