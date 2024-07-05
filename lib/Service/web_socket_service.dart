import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:remote_assist/Dtos/UserRaDto.dart';
import 'package:remote_assist/Service/UserService.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService with ChangeNotifier {
  final UserService _userService = UserService();
  UserRaDto? _currentUser;
  StompClient? stompClient;
  List<Map<String, dynamic>> messages = [];



  Future<void> initializeUser() async {
    try {
      _currentUser = await _userService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur: $e');
    }
  }

  String? get userName => _currentUser?.nom;
  void connect() {
    if (_currentUser == null) {
      print('Erreur : Utilisateur non authentifié');
      return;
    }

    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.1.118:8081/chat-socket',
        onConnect: onConnect,
        beforeConnect: () async {
          print('Attente de connexion...');
          await Future.delayed(Duration(milliseconds: 200));
          print('Connexion en cours...');
        },
        onWebSocketError: (dynamic error) => print('Erreur WebSocket: $error'),
        onStompError: (StompFrame frame) => print('Erreur STOMP: ${frame.body}'),
        onDisconnect: (StompFrame frame) => print('Déconnecté: ${frame.body}'),
        onDebugMessage: (dynamic message) => print('Debug: $message'),
      ),
    );

    stompClient!.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connecté: ${frame.headers}');
    stompClient!.subscribe(
      destination: '/topic/room1',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var message = json.decode(frame.body!);
          if (message is Map<String, dynamic> && message.containsKey('message') && message.containsKey('user')) {
            try {
              message['date'] = DateTime.parse(message['date']);
            } catch (e) {
              message['date'] = DateTime.now();
            }
            messages.add(message);
            notifyListeners();
          }
          print('Message reçu: $message');
        }
      },
    );

    stompClient!.subscribe(
      destination: '/topic/webrtc/room1',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          var signal = json.decode(frame.body!);
          handleWebRTCSignal(signal);
        }
      },
    );
  }

  void sendMessage(String message) {
    if (userName != null && stompClient != null && stompClient!.connected) {
      stompClient!.send(
        destination: '/app/chat/room1',
        body: json.encode({
          'message': message,
          'user': userName,
          'date': DateTime.now().toIso8601String()
        }),
      );
    } else {
      print('Erreur : Impossible d\'envoyer le message. Vérifiez la connexion et le nom d\'utilisateur.');
    }
  }

  void disconnect() {
    if (stompClient != null && stompClient!.connected) {
      stompClient!.deactivate();
    }
  }

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

  Future<void> initializePeerConnection() async {
    final Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    peerConnection = await createPeerConnection(configuration);

    localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true
    });
    notifyListeners();

    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
    });

    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      sendWebRTCSignal({
        'type': 'ice_candidate',
        'candidate': candidate.toMap(),
      });
    };

    peerConnection!.onTrack = (RTCTrackEvent event) {
      remoteStream = event.streams[0];
      notifyListeners();
    };
  }

  void sendWebRTCSignal(Map<String, dynamic> signal) {
    stompClient!.send(
      destination: '/app/webrtc/room1',
      body: json.encode(signal),
    );
  }

  void handleWebRTCSignal(Map<String, dynamic> signal) async {
    switch (signal['type']) {
      case 'offer':
        await peerConnection!.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signal['type']),
        );
        final answer = await peerConnection!.createAnswer();
        await peerConnection!.setLocalDescription(answer);
        sendWebRTCSignal({
          'type': 'answer',
          'sdp': answer.sdp,
        });
        break;
      case 'answer':
        await peerConnection!.setRemoteDescription(
          RTCSessionDescription(signal['sdp'], signal['type']),
        );
        break;
      case 'ice_candidate':
        await peerConnection!.addCandidate(
          RTCIceCandidate(
            signal['candidate']['candidate'],
            signal['candidate']['sdpMid'],
            signal['candidate']['sdpMLineIndex'],
          ),
        );
        break;
    }
  }


}