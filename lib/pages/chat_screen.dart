import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:remote_assist/Service/web_socket_service.dart';

class ChatScreen extends StatefulWidget {
  final String roomCode;

  ChatScreen({required this.roomCode});

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
    webSocketService.connect(widget.roomCode);
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
      appBar: AppBar(
        title: Text('Chat Room: ${widget.roomCode}'),
      ),
      body: Column(
        children: <Widget>[
          if (!isConnected)
            Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: Consumer<WebSocketService>(
                builder: (context, webSocketService, child) {
                  var roomMessages = webSocketService.getMessagesForRoom(widget.roomCode);
                  print('Building ListView. Message count: ${roomMessages.length}');
                  return ListView.builder(
                    itemCount: roomMessages.length,
                    itemBuilder: (context, index) {
                      var message = roomMessages[index];
                      print('Building message at index $index: $message');
                      var isOwnMessage = message['user'] == webSocketService.userName;
                      return Align(
                        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isOwnMessage ? Color(0xFFFFCDD2) : Colors.white,
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
                                message['user']?.toString() ?? 'Unknown User',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isOwnMessage ? Colors.red : Colors.blue,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                message['message']?.toString() ?? '',
                                style: TextStyle(color: isOwnMessage ? Colors.black : Colors.black87),
                              ),
                              SizedBox(height: 5),
                              Text(
                                message['date'] != null
                                    ? DateFormat('HH:mm').format(DateTime.parse(message['date']))
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
                      webSocketService.sendMessage(widget.roomCode, _messageController.text);
                      _messageController.clear();
                    }
                  },
                  child: Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(14),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
