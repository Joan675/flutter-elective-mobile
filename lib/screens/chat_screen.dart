import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import '../static/app_sidebar.dart';
import '../services/gemini_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


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

    final isFirstUserMessage = _messages.where((m) => m.startsWith('User:')).isEmpty;

    setState(() {
      _messages.add('$sender: $text');
      if (_messages.length > 10) _messages.removeAt(0);
    });
    await _saveMessages();

    final memory = isFirstUserMessage ? List<String>.from(_messages) : null;
    final response = await GeminiService.getGeminiResponse(text, memory: memory);

    setState(() {
      _messages.add('Synciee: $response');
      if (_messages.length > 10) _messages.removeAt(0);
    });
    await _saveMessages();

    Future.delayed(const Duration(milliseconds: 300), () {
      final position = _scrollController.position;
      final isNearBottom = position.pixels <= position.minScrollExtent + 100;

      if (isNearBottom) {
        _scrollController.animateTo(
          position.minScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('chat_messages');
    if (stored != null && mounted) {
      setState(() => _messages.addAll(stored));
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('chat_messages', _messages);
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
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
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemCount: _messages.length,
                      itemBuilder: (_, i) {
                        final reversedIndex = _messages.length - 1 - i;
                        final message = _messages[reversedIndex];
                        final isBot = message.startsWith('Synciee:');
                        final displayText = message.replaceFirst(RegExp(r'^(Synciee|User):\s*'), '');
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            decoration: BoxDecoration(
                              color: isBot ? Colors.white : Colors.indigo.shade600,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(isBot ? 0 : 18),
                                bottomRight: Radius.circular(isBot ? 18 : 0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              displayText,
                              style: TextStyle(
                                color: isBot ? Colors.black87 : Colors.white,
                                fontSize: 15.5,
                                height: 1.4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) {
                              _sendMessage(_inputController.text);
                              _inputController.clear();
                            },
                            decoration: InputDecoration(
                              hintText: 'Ask Synciee...',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              _sendMessage(_inputController.text);
                              _inputController.clear();
                            },
                          ),
                        ),
                      ],
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
