import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:remote_assist/Service/web_socket_service.dart';

class VideoConferenceScreen extends StatefulWidget {
  @override
  _VideoConferenceScreenState createState() => _VideoConferenceScreenState();
}
class _VideoConferenceScreenState extends State<VideoConferenceScreen> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    _initializeWebRTC();
  }

  void _initializeWebRTC() async {
    final webSocketService = Provider.of<WebSocketService>(context, listen: false);
    await webSocketService.initializePeerConnection();
    setState(() {
      _localRenderer.srcObject = webSocketService.localStream;
      _remoteRenderer.srcObject = webSocketService.remoteStream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Vidéo principale (simulant le distant)
          Positioned.fill(
            child: RTCVideoView(_remoteRenderer),
          ),
          // Vidéo locale (petite fenêtre)
          Positioned(
            top: 20,
            right: 20,
            width: 100,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: RTCVideoView(_localRenderer),
              ),
            ),
          ),
          // Barre de contrôle en bas
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.videocam, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.mic_off, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.call_end, color: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Nom de l'interlocuteur (simulé)
          Positioned(
            bottom: 80,
            left: 20,
            child: Text(
              'John Doe is speaking',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }
}