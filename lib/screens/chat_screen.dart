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
  bool _isSyncieeTyping = false;

  void _sendMessage(String text, {String sender = 'User'}) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add('$sender: $text');
      if (_messages.length > 10) _messages.removeAt(0);
      _isSyncieeTyping = true;
      _messages.add('Synciee: ...typing...');
    });
    await _saveMessages();

    try {
      final memory =
          _messages.where((m) => !m.contains('...typing...')).take(10).toList();

      final response = await GeminiService.getGeminiResponse(
        text,
        memory: memory,
      );

      setState(() {
        _messages.removeLast();
        _messages.add('Synciee: $response');
        if (_messages.length > 10) _messages.removeAt(0);
        _isSyncieeTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(
          "Synciee: Oops! Something went wrong while trying to respond. Can you try again in a moment?",
        );
        _isSyncieeTyping = false;
      });
    }

    await _saveMessages();

    Future.delayed(const Duration(milliseconds: 300), () {
      final position = _scrollController.position;
      final isUserAtBottom = position.pixels >= position.maxScrollExtent - 100;

      if (isUserAtBottom) {
        _scrollController.animateTo(
          position.maxScrollExtent,
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

bool _showSuggestions = false;

final List<String> _predefinedMessages = [
  "What are common side effects of Paracetamol?",
  "How often should I take my medication?",
  "Can I take ibuprofen on an empty stomach?",
  "What should I do if I miss a dose?",
  "Are there foods I should avoid with antibiotics?"
];


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
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

            return Stack(
              children: [
                const WavyBackground(),
                SafeArea(
                  child: Column(
                    children: [
                      // ✅ This is your existing Expanded message list + input bar
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (_, i) {
                            final reversedIndex = _messages.length - 1 - i;
                            final message = _messages[reversedIndex];
                            final isBot = message.startsWith('Synciee:');
                            final isTyping = message == 'Synciee: ...typing...';
                            final displayText =
                                isTyping
                                    ? ''
                                    : message.replaceFirst(
                                      RegExp(r'^(Synciee|User):\s*'),
                                      '',
                                    );
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              alignment:
                                  isBot
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                              child:
                                  isTyping
                                      ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const SizedBox(
                                              height: 12,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _Dot(),
                                                  SizedBox(width: 4),
                                                  _Dot(delay: 200),
                                                  SizedBox(width: 4),
                                                  _Dot(delay: 400),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 6,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.75,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isBot
                                                  ? Colors.white
                                                  : Colors.indigo.shade600,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(18),
                                            topRight: const Radius.circular(18),
                                            bottomLeft: Radius.circular(
                                              isBot ? 0 : 18,
                                            ),
                                            bottomRight: Radius.circular(
                                              isBot ? 18 : 0,
                                            ),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          displayText,
                                          style: TextStyle(
                                            color:
                                                isBot
                                                    ? Colors.black87
                                                    : Colors.white,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
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
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
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

                // ✅ Keyboard-aware floating button
// FAB + Floating List
Positioned(
  bottom: keyboardHeight + 100,
  right: 20,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (_showSuggestions)
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _predefinedMessages.map((msg) {
              return GestureDetector(
                onTap: () {
                  setState(() => _showSuggestions = false);
                  _sendMessage(msg);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Text(
                    msg,
                    style: const TextStyle(fontSize: 13.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      FloatingActionButton(
        heroTag: 'predefined-messages',
        onPressed: () {
          setState(() => _showSuggestions = !_showSuggestions);
        },
        backgroundColor: Colors.indigo.shade300,
        mini: true,
        child: const Icon(Icons.question_answer, color: Colors.white),
      ),
    ],
  ),
),

              ],
            );
          },
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({this.delay = 0});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isAnimating == false) {
      return const SizedBox(width: 6, height: 6);
    }

    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
