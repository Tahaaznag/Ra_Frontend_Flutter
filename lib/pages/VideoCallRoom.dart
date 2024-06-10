import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:remote_assist/Service/VideoCallService.dart';
import 'package:remote_assist/pages/VideoCallPage.dart';

class VideoCallRoom extends StatefulWidget {
  @override
  _VideoCallRoomState createState() => _VideoCallRoomState();
}

class _VideoCallRoomState extends State<VideoCallRoom> {
  final VideoCallService _service = VideoCallService();

  @override
  void initState() {
    super.initState();
    _service.initializeRenderers();
    _service.initializeWebRTC();
    _service.connectToWebSocket();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call Room ${VideoCallPage.sessionId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(_service.localRenderer),
          ),
          Expanded(
            child: RTCVideoView(_service.remoteRenderer),
          ),
        ],
      ),
    );
  }
}
