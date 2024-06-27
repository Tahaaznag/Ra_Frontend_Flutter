import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService with ChangeNotifier {
  StompClient? stompClient;
  List<Map<String, dynamic>> messages = [];

  String? userName;

  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.50.100.6:8081/chat-socket',
        onConnect: onConnect,
        beforeConnect: () async {
          print('Waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('Connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        onStompError: (StompFrame frame) => print(frame.toString()),
        onDisconnect: (StompFrame frame) => print('Disconnected: ${frame.body}'),
        onDebugMessage: (dynamic message) => print('Debug: $message'),
      ),
    );

    stompClient!.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connected: ${frame.headers}');
    stompClient!.subscribe(
      destination: '/topic/room1',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var message = json.decode(frame.body!);
          if (message is Map<String, dynamic> && message.containsKey('message') && message.containsKey('user')) {
            // Ensure the date is correctly parsed
            try {
              message['date'] = DateTime.parse(message['date']);
            } catch (e) {
              message['date'] = DateTime.now();
            }
            messages.add(message);
            notifyListeners();
          }
          print('Received message: $message');
        }
      },
    );
  }

  void sendMessage(String message) {
    if (userName != null) {
      stompClient!.send(
        destination: '/app/chat/room1',
        body: json.encode({'message': message, 'user': userName, 'date': DateTime.now().toIso8601String()}),
      );
    }
  }

  void disconnect() {
    stompClient!.deactivate();
  }
}
