import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebRTCService {
  late StompClient _stompClient;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  final String _roomCode;
  Function(MediaStream)? onLocalStream;
  Function(MediaStream)? onRemoteStream;
  bool _isInitiator = false;
  bool _offerReceived = false;
  List<RTCIceCandidate> _queuedIceCandidates = [];
  bool _remoteDescriptionSet = false;
  Completer<void> _offerReceivedCompleter = Completer<void>();

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
    print("Initializing peer connection");
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
        {'urls': 'stun:stun2.l.google.com:19302'},
        {'urls': 'stun:stun3.l.google.com:19302'},
        {'urls': 'stun:stun4.l.google.com:19302'},
        {
          'urls': 'turn:numb.viagenie.ca',
          'username': 'webrtc@live.com',
          'credential': 'muazkh'
        }
      ]
    });

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      print("ICE candidate generated: ${candidate.toMap()}");
      _sendSignalingMessage({
        'type': 'ice',
        'candidate': candidate.toMap(),
      });
    };

    _peerConnection!.onAddStream = (MediaStream stream) {
      print("Stream added: ${stream.id}");
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

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      print('Received remote track: ${event.track.kind}');
      if (event.track.kind == 'video') {
        _remoteStream = event.streams[0];
        if (onRemoteStream != null) {
          onRemoteStream!(_remoteStream!);
        }
      }
    };

    print("Peer connection initialized");
  }

  Future<void> waitForOffer() async {
    print("Waiting for offer");
    if (!_offerReceived) {
      await _offerReceivedCompleter.future;
    }
    print("Offer received");
  }

  Future<void> createAnswer() async {
    print("Creating answer");
    if (_peerConnection != null && _offerReceived && _remoteDescriptionSet) {
      try {
        RTCSessionDescription answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        _sendSignalingMessage({
          'type': 'answer',
          'sdp': answer.sdp,
        });
        print("Answer created and sent");
      } catch (e) {
        print("Error creating answer: $e");
        throw e;
      }
    } else {
      print("Cannot create answer: no offer received, remote description not set, or no peer connection");
      throw Exception("Cannot create answer: preconditions not met");
    }
  }

  Future<void> startLocalStream({bool isScreenSharing = false}) async {
    print("Starting local stream (screen sharing: $isScreenSharing)");
    Map<String, dynamic> constraints;
    if (isScreenSharing) {
      constraints = {
        'audio': false,
        'video': {'mandatory': {'minWidth': '640', 'minHeight': '480'}}
      };
      _localStream = await navigator.mediaDevices.getDisplayMedia(constraints);
    } else {
      constraints = {
        'audio': true,
        'video': {'mandatory': {'minWidth': '640', 'minHeight': '480'}}
      };
      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    }

    print('Local stream started with ${_localStream!.getVideoTracks().length} video tracks and ${_localStream!.getAudioTracks().length} audio tracks');

    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    if (onLocalStream != null) {
      onLocalStream!(_localStream!);
    }
  }

  Future<void> createOffer() async {
    print("Creating offer");
    if (!_isInitiator && !_offerReceived) {
      _isInitiator = true;
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      _sendSignalingMessage({
        'type': 'offer',
        'sdp': offer.sdp,
      });
      print("Offer created and sent");
    } else {
      print("Cannot create offer: already initiator or offer already received");
    }
  }

  void _handleSignalingMessage(String message) {
    print("Received signaling message: $message");
    try {
      final Map<String, dynamic> data = jsonDecode(message);

      switch (data['type']) {
        case 'offer':
          print("Handling offer");
          _handleOffer(RTCSessionDescription(data['sdp'], 'offer'));
          break;
        case 'answer':
          print("Handling answer");
          _handleAnswer(RTCSessionDescription(data['sdp'], 'answer'));
          break;
        case 'ice':
          print("Handling ICE candidate");
          _handleIceCandidate(RTCIceCandidate(
            data['candidate']['candidate'],
            data['candidate']['sdpMid'],
            data['candidate']['sdpMLineIndex'],
          ));
          break;
        default:
          print('Unknown message type: ${data['type']}');
      }
    } catch (e) {
      print('Error handling signaling message: $e');
    }
  }

  Future<void> _handleOffer(RTCSessionDescription offer) async {
    print('Handling offer: ${offer.sdp}');
    if (!_isInitiator) {
      _offerReceived = true;
      try {
        await _peerConnection?.setRemoteDescription(offer);
        _remoteDescriptionSet = true;
        _queuedIceCandidates.forEach((candidate) async {
          await _peerConnection?.addCandidate(candidate);
        });
        _queuedIceCandidates.clear();
        _offerReceivedCompleter.complete();
        print("Remote description set and offer handled");
      } catch (e) {
        print('Error handling offer: $e');
        _offerReceivedCompleter.completeError(e);
      }
    } else {
      print("Ignoring offer: already initiator");
    }
  }

  Future<void> _handleAnswer(RTCSessionDescription answer) async {
    print('Handling answer: ${answer.sdp}');
    if (_isInitiator) {
      try {
        await _peerConnection?.setRemoteDescription(answer);
        _remoteDescriptionSet = true;
        _queuedIceCandidates.forEach((candidate) async {
          await _peerConnection?.addCandidate(candidate);
        });
        _queuedIceCandidates.clear();
        print("Remote description set and queued ICE candidates added");
      } catch (e) {
        print('Error handling answer: $e');
      }
    } else {
      print("Ignoring answer: not initiator");
    }
  }

  Future<void> _handleIceCandidate(RTCIceCandidate candidate) async {
    if (_remoteDescriptionSet) {
      try {
        print('Adding ICE candidate: ${candidate.toMap()}');
        await _peerConnection?.addCandidate(candidate);
      } catch (e) {
        print('Error adding ICE candidate: $e');
      }
    } else {
      print('Queuing ICE candidate: ${candidate.toMap()}');
      _queuedIceCandidates.add(candidate);
    }
  }

  void dispose() {
    print("Disposing WebRTCService");
    _stompClient.deactivate();
    _peerConnection?.close();
    _localStream?.dispose();
    _remoteStream?.dispose();
  }
}