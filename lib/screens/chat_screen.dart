// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final TextEditingController _inputController = TextEditingController();

  void _sendMessage(String text, {String sender = 'User'}) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add('$sender: $text');
      if (sender == 'User') {
        if (text.toLowerCase().contains('hello')) {
          _messages.add('Synciee: Hi there!');
        } else if (text.toLowerCase().contains('how are you')) {
          _messages.add('Synciee: I\'m doing well, thank you!');
        } else {
          _messages.add('Synciee: That\'s interesting.');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Talk to Synciee')),
      body: Column(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) => Text(_messages[i]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                decoration: const InputDecoration(hintText: 'Ask Synciee', border: OutlineInputBorder()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _sendMessage(_inputController.text);
                _inputController.clear();
              },
            ),
          ]),
        ),
      ]),
    );
  }
}
