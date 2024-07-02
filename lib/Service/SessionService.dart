import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remote_assist/Dtos/SessioRaDto.dart';

class SessionService {
  static const String baseUrl = 'http://10.50.100.6:8081'; // Remplacez par votre URL de base
  static const String sessionEndpoint = '/api/session';

  Future<SessionRaDto> createSession(SessionRaDto sessionDto, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$sessionEndpoint/create?userId=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sessionDto.toJson()),
    );

    if (response.statusCode == 201) {
      return SessionRaDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create session');
    }
  }

  Future<SessionRaDto> joinSession(String roomCode, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl$sessionEndpoint/join/$roomCode?userId=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return SessionRaDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to join session');
    }
  }
}