import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:remote_assist/Service/web_socket_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeAndConnect();
  }

  Future<void> _initializeAndConnect() async {
    final webSocketService = Provider.of<WebSocketService>(context, listen: false);
    await webSocketService.initializeUser();
    webSocketService.connect();
    setState(() {
      isConnected = true;
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      final webSocketService = Provider.of<WebSocketService>(context, listen: false);
      webSocketService.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final webSocketService = Provider.of<WebSocketService>(context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          if (!isConnected) ...[
            CircularProgressIndicator(),

          ] else ...[
            Expanded(
              child: Consumer<WebSocketService>(
                builder: (context, webSocketService, child) {
                  return ListView.builder(
                    itemCount: webSocketService.messages.length,
                    itemBuilder: (context, index) {
                      var message = webSocketService.messages[index];
                      var isOwnMessage = message['user'] == webSocketService.userName;
                      return Align(
                        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isOwnMessage ? Color(0xFFFFCDD2) : Colors.white, // Changed to red
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['user'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isOwnMessage ? Colors.red : Colors.blue,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                message['message'] ?? '',
                                style: TextStyle(color: isOwnMessage ? Colors.black : Colors.black87),
                              ),
                              SizedBox(height: 5),
                              Text(
                                message['date'] is DateTime
                                    ? DateFormat('HH:mm').format(message['date'])
                                    : '',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        webSocketService.sendMessage(_messageController.text);
                        _messageController.clear();
                      }
                    },
                    child: Icon(Icons.send),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14), backgroundColor: Theme.of(context).primaryColor,
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}