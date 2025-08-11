import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ConversationState();
}

class _ConversationState extends State<Chatbot> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages =
      []; // { text: '...', isMe: true/false }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isMe': true}); // Your message (left)
      _messages.add({'text': text, 'isMe': false}); // Simulated reply (right)
    });

    _messageController.clear();
  }

  Widget _buildMessage(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isMe ? Colors.red[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("User Name")),
        body: Column(
          children: [
            // Messages area
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessage(message['text'], message['isMe']);
                },
              ),
            ),

            // Input area
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Write Message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                    IconButton(onPressed: _sendMessage, icon: Icon(Icons.send)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
