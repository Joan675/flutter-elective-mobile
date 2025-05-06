import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import '../static/app_sidebar.dart';
import '../services/gemini_service.dart'; // make sure the path is correct

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String text, {String sender = 'User'}) async {
  if (text.trim().isEmpty) return;
  setState(() {
    _messages.add('$sender: $text');
  });

  final response = await GeminiService.getGeminiResponse(text);

  setState(() {
    _messages.add('Synciee: $response');
  });

  Future.delayed(Duration(milliseconds: 100), () {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Talk to Synciee'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const WavyBackground(),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true, // 👈 Messages appear from bottom
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final reversedIndex = _messages.length - 1 - i;
                          final message = _messages[reversedIndex];
                          final isBot = message.startsWith('Synciee:');
                          final displayText = message.replaceFirst('Synciee: ', '').replaceFirst('User: ', '');
                          return Align(
                            alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                              decoration: BoxDecoration(
                                color: isBot ? Colors.indigo.shade100 : Colors.indigo.shade400,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(isBot ? 0 : 16),
                                  bottomRight: Radius.circular(isBot ? 16 : 0),
                                ),
                              ),
                              child: Text(
                                displayText,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isBot ? Colors.black87 : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'Ask Synciee',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.indigo.shade900, width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.indigo.shade900, width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.indigo.shade900, width: 3),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.indigo),
                          onPressed: () {
                            _sendMessage(_inputController.text);
                            _inputController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}