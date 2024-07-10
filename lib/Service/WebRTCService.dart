import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebRTCService {
  late StompClient _stompClient;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  final String _roomCode;
  Function(MediaStream)? onLocalStream;
  Function(MediaStream)? onRemoteStream;
  bool _isInitiator = false;

  WebRTCService(String serverUrl, this._roomCode) {
    _stompClient = StompClient(
      config: StompConfig(
        url: serverUrl,
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
      ),
    );
  }

  void connect() {
    print("Attempting to connect to ${_stompClient.config.url}");
    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    print("Connected to WebSocket server");
    _stompClient.subscribe(
      destination: '/topic/$_roomCode',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          _handleSignalingMessage(frame.body!);
        }
      },
    );
    print("Subscribed to /topic/$_roomCode");
  }

  void _sendSignalingMessage(Map<String, dynamic> message) {
    _stompClient.send(
      destination: '/app/webrtc/$_roomCode',
      body: jsonEncode(message),
    );
    print("Sent signaling message: ${jsonEncode(message)}");
  }

  Future<void> initializePeerConnection() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    });

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _sendSignalingMessage({
        'type': 'ice',
        'candidate': candidate.toMap(),
      });
    };

    _peerConnection!.onAddStream = (MediaStream stream) {
      _remoteStream = stream;
      if (onRemoteStream != null) {
        onRemoteStream!(stream);
      }
    };

    _peerConnection!.onSignalingState = (RTCSignalingState state) {
      print('Signaling state changed: $state');
    };

    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state changed: $state');
    };
  }

  Future<void> startLocalStream({bool isScreenSharing = false}) async {
    if (isScreenSharing) {
      _localStream = await navigator.mediaDevices.getDisplayMedia({
        'audio': false,
        'video': true,
      });
    } else {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': true,
      });
    }

    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    if (onLocalStream != null) {
      onLocalStream!(_localStream!);
    }
  }

  Future<void> createOffer() async {
    _isInitiator = true;
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    _sendSignalingMessage({
      'type': 'offer',
      'sdp': offer.sdp,
    });
  }

  void _handleSignalingMessage(String message) {
    print("Received signaling message: $message");
    final Map<String, dynamic> data = jsonDecode(message);

    switch (data['type']) {
      case 'offer':
        print('Received offer');
        _handleOffer(RTCSessionDescription(data['sdp'], 'offer'));
        break;
      case 'answer':
        print('Received answer');
        _handleAnswer(RTCSessionDescription(data['sdp'], 'answer'));
        break;
      case 'ice':
        print('Received ICE candidate');
        _handleIceCandidate(RTCIceCandidate(
          data['candidate']['candidate'],
          data['candidate']['sdpMid'],
          data['candidate']['sdpMLineIndex'],
        ));
        break;
      default:
        print('Unknown message type: ${data['type']}');
    }
  }

  Future<void> _handleOffer(RTCSessionDescription offer) async {
    if (!_isInitiator) {
      try {
        print('Setting remote description with offer');
        await _peerConnection?.setRemoteDescription(offer);
        RTCSessionDescription answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        _sendSignalingMessage({
          'type': 'answer',
          'sdp': answer.sdp,
        });
        print('Sent answer');
      } catch (e) {
        print('Error handling offer: $e');
      }
    } else {
      print('Ignoring offer as we are the initiator');
    }
  }

  Future<void> _handleAnswer(RTCSessionDescription answer) async {
    if (_isInitiator) {
      try {
        print('Setting remote description with answer');
        await _peerConnection?.setRemoteDescription(answer);
      } catch (e) {
        print('Error handling answer: $e');
      }
    } else {
      print('Ignoring answer as we are not the initiator');
    }
  }

  Future<void> _handleIceCandidate(RTCIceCandidate candidate) async {
    try {
      await _peerConnection?.addCandidate(candidate);
    } catch (e) {
      print('Error adding ICE candidate: $e');
    }
  }

  void dispose() {
    _stompClient.deactivate();
    _peerConnection?.close();
    _localStream?.dispose();
    _remoteStream?.dispose();
  }
}