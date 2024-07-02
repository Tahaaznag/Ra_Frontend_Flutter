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
  bool _isMicMuted = false;
  bool _isCameraOff = false;

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
      _remoteRenderer.srcObject = webSocketService.localStream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: RTCVideoView(_remoteRenderer),
          ),
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
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularButton(Icons.mic_off, _isMicMuted, _toggleMic),
                _buildCircularButton(Icons.videocam_off, _isCameraOff, _toggleCamera),
                _buildCircularButton(Icons.call_end, false, _endCall, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, bool isActive, VoidCallback onPressed, {Color color = Colors.white}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: isActive ? Colors.red : color,
      child: Icon(icon, color: isActive ? Colors.white : Colors.black),
    );
  }

  void _toggleMic() {
    setState(() => _isMicMuted = !_isMicMuted);
    // Implement mic toggling logic
  }

  void _toggleCamera() {
    setState(() => _isCameraOff = !_isCameraOff);
    // Implement camera toggling logic
  }

  void _endCall() {
    // Implement call ending logic
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }
}