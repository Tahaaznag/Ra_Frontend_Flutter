import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../Service/WebRTCService.dart';

class VideoScreen extends StatefulWidget {
  final String roomCode;

  const VideoScreen({Key? key, required this.roomCode}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late WebRTCService _webRTCService;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isCallActive = false;
  bool _isScreenSharing = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    _webRTCService = WebRTCService(
      'ws://10.50.100.26:8081/webrtc-signaling',
      widget.roomCode,
    );

    _webRTCService.onLocalStream = (stream) {
      setState(() {
        _localRenderer.srcObject = stream;
      });
      print('Local stream set');
    };

    _webRTCService.onRemoteStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
        _isCallActive = true;
      });
      print('Remote stream set');
    };

    await _webRTCService.initializePeerConnection();
    _webRTCService.connect();
  }

  Future<void> _startCall({bool isScreenSharing = false}) async {
    try {
      await _webRTCService.startLocalStream(isScreenSharing: isScreenSharing);
      await _webRTCService.createOffer();
      setState(() {
        _isCallActive = true;
        _isScreenSharing = isScreenSharing;
      });
      print('Call started');
    } catch (e) {
      print('Erreur lors du démarrage de l\'appel : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du démarrage de l\'appel')),
      );
    }
  }

  void _endCall() {
    _webRTCService.dispose();
    setState(() {
      _isCallActive = false;
      _isScreenSharing = false;
      _localRenderer.srcObject = null;
      _remoteRenderer.srcObject = null;
    });
    print('Call ended');
  }

  void _toggleScreenSharing() async {
    if (_isScreenSharing) {
      await _startCall(isScreenSharing: false);
    } else {
      await _startCall(isScreenSharing: true);
    }
    print('Screen sharing toggled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appel Vidéo - Salle ${widget.roomCode}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(
              _localRenderer,
              mirror: true,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
          Expanded(
            child: RTCVideoView(
              _remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_isCallActive)
                  ElevatedButton(
                    onPressed: () => _startCall(),
                    child: Text('Démarrer l\'appel'),
                  ),
                if (_isCallActive)
                  ElevatedButton(
                    onPressed: _toggleScreenSharing,
                    child: Text(_isScreenSharing
                        ? 'Arrêter le partage d\'écran'
                        : 'Partager l\'écran'),
                  ),
                if (_isCallActive)
                  ElevatedButton(
                    onPressed: _endCall,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Terminer l\'appel'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _webRTCService.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }
}
