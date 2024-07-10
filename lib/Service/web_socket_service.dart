import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:remote_assist/Service/UserService.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService with ChangeNotifier {
  late StompClient _stompClient;
  late UserRaDto user;
  String userName = '';
  String currentRoomCode = '';
  List<Map<String, dynamic>> messages = [];
  bool _isConnected = false;

  WebSocketService() {
    initializeUser();
  }

  Future<void> initializeUser() async {
    user = await UserService().getCurrentUser();
    userName = user.nom;
  }

  void connect(String roomCode) {
    currentRoomCode = roomCode;
    print('Connecting to room: $roomCode');
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.135:8081/chat-socket',
        onConnect: (StompFrame frame) {
          print('Connected to WebSocket');
          _isConnected = true;
          notifyListeners();

          _stompClient.subscribe(
            destination: '/topic/$roomCode',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                print('Frame received: ${frame.body}');
                try {

                  final decodedMessage = json.decode(frame.body!);
                  print('Message received and decoded: $decodedMessage');
                  decodedMessage['roomCode'] = roomCode;
                  messages.add(decodedMessage);
                  print('Messages list updated. Current count: ${messages.length}');
                  notifyListeners();
                  print('Listeners notified');
                } catch (e) {
                  print('Error decoding message: $e');
                }
              } else {
                print('Received empty frame');
              }
            },
          );
        },
        onWebSocketError: (dynamic error) {
          print('WebSocket error: $error');
          _isConnected = false;
          notifyListeners();
        },
        // ... rest of the config
      ),
    );

    _stompClient.activate();
  }

  void sendMessage(String roomCode, String message) {
    final dateTime = DateTime.now().toIso8601String();
    final encodedMessage = json.encode({
      'user': userName,
      'message': message,
      'date': dateTime,
      'roomCode': roomCode,
    });

    print('Sending message: $encodedMessage');
    _stompClient.send(
      destination: '/app/chat/$roomCode',
      body: encodedMessage,
    );
  }
  List<Map<String, dynamic>> getMessagesForRoom(String roomCode) {
    return messages.where((message) => message['roomCode'] == roomCode).toList();
  }

  void disconnect() {
    if (_isConnected) {
      _stompClient.deactivate();
      _isConnected = false;
      print('Disconnected from WebSocket');
      notifyListeners();
    }
  }
}
