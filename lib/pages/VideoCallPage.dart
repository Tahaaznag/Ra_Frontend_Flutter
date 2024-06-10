import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remote_assist/Service/VideoCallService.dart' ;
import 'package:remote_assist/pages/VideoCallRoom.dart';


class VideoCallPage extends StatelessWidget {
  static String sessionId = '';
  static String userId = '';

  final VideoCallService _seervice = VideoCallService();
  final TextEditingController _sessionIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _sessionIdController,
              decoration: InputDecoration(
                labelText: 'Session ID',
              ),
            ),
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                VideoCallPage.sessionId = _sessionIdController.text;
                VideoCallPage.userId = _userIdController.text;
                await _seervice.initializeRenderers();
                await _seervice.initializeWebRTC();
                _seervice.connectToWebSocket();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallRoom(),
                  ),
                );
              },
              child: Text('Join Call'),
            ),
          ],
        ),
      ),
    );
  }
}
