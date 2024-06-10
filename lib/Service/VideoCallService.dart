import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remote_assist/pages/VideoCallPage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class VideoCallService {
  late StompClient stompClient;
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;
  late RTCVideoRenderer _localRenderer; // Define _localRenderer here
  late RTCVideoRenderer _remoteRenderer;

  // Getter for _localRenderer
  RTCVideoRenderer get localRenderer => _localRenderer;

  // Getter for _remoteRenderer
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  Future<void> requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> initializeRenderers() async {
    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    print("Renderers initialized");
  }

  Future<void> initializeWebRTC() async {
    Map<String, dynamic> configuration = {
      'ServeurICE' : [
        {
          'urls' : [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
        'audio': true,
      });
      print("Local stream initialized");

      _peerConnection = await createPeerConnection(configuration);
      _peerConnection.addStream(_localStream);
      print("Peer connection created and local stream added");

      _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate != null) {
          print("New ICE candidate: ${candidate.candidate}");
          stompClient.send(
            destination: '/app/webrtc.candidate',
            body: jsonEncode({
              'type': 'candidate',
              'candidate': candidate.candidate,
              'sdpMLineIndex': candidate.sdpMLineIndex,
              'sdpMid': candidate.sdpMid,
              'sessionId': VideoCallPage.sessionId,
              'userId': VideoCallPage.userId,
            }),
          );
        }
      };

      _peerConnection.onAddStream = (MediaStream stream) {
        print("Remote stream added");
        _remoteRenderer.srcObject = stream;
      };

      if (VideoCallPage.userId == 'caller') {
        RTCSessionDescription offer = await _peerConnection.createOffer();
        await _peerConnection.setLocalDescription(offer);
        print("Offer created and sent: ${offer.sdp}");
        stompClient.send(
          destination: '/app/webrtc.offer',
          body: jsonEncode({
            'type': 'offer',
            'sdp': offer.sdp,
            'sessionId': VideoCallPage.sessionId,
            'userId': VideoCallPage.userId,
          }),
        );
      }
    } catch (e) {
      print("Error initializing WebRTC: $e");
    }
  }

  void connectToWebSocket() {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://10.50.100.15/ws',
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print("WebSocket error: $error"),
      ),
    );

    stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    print("Connected to WebSocket");
    stompClient.subscribe(
      destination: '/queue/response',
      callback: (frame) {
        print("Received frame: ${frame.body}");
        Map<String, dynamic> result = jsonDecode(frame.body!);
        if (result['type'] == 'offer' && VideoCallPage.userId != 'caller') {
          _handleOffer(result);
        } else if (result['type'] == 'answer' && VideoCallPage.userId == 'caller') {
          _handleAnswer(result);
        } else if (result['type'] == 'candidate') {
          _handleCandidate(result);
        }
      },
    );
  }

  void _handleOffer(Map<String, dynamic> result) async {
    print("Handling offer: ${result['sdp']}");
    await _peerConnection.setRemoteDescription(
      RTCSessionDescription(result['sdp'], result['type']),
    );

    RTCSessionDescription answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);
    print("Answer created and sent: ${answer.sdp}");

    stompClient.send(
      destination: '/app/webrtc.answer',
      body: jsonEncode({
        'type': 'answer',
        'sdp': answer.sdp,
        'sessionId': VideoCallPage.sessionId,
        'userId': VideoCallPage.userId,
      }),
    );
  }

  void _handleAnswer(Map<String, dynamic> result) async {
    print("Handling answer: ${result['sdp']}");
    await _peerConnection.setRemoteDescription(
      RTCSessionDescription(result['sdp'], result['type']),
    );
  }

  void _handleCandidate(Map<String, dynamic> result) async {
    print("Handling candidate: ${result['candidate']}");
    await _peerConnection.addCandidate(
      RTCIceCandidate(
        result['candidate'],
        result['sdpMid'],
        result['sdpMLineIndex'],
      ),
    );
  }

  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection.close();
    _localStream.dispose();
    stompClient.deactivate();
  }
}
