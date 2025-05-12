import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY']!;
  static final String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  static Future<String> getGeminiResponse(
    String prompt, {
    List<String>? memory,
  }) async {
    final List<Map<String, dynamic>> parts = [];

    // ✅ STEP 3: Insert system-style prompt first (acts like a system message)
    parts.add({
      'role': 'user',
      'parts': [
        {
          'text':
              'You are Synciee, a helpful and knowledgeable medical assistant. Provide clear, accurate, and safe health information. '
              'Avoid speculation, avoid giving unverified advice, and ask clarifying questions if needed.',
        },
      ],
    });

    // ✅ Add past chat memory as context (structured role-based messages)
    if (memory != null) {
      for (final m in memory) {
        if (m.startsWith("User:")) {
          parts.add({
            'role': 'user',
            'parts': [
              {'text': m.replaceFirst("User:", "").trim()},
            ],
          });
        } else if (m.startsWith("Synciee:")) {
          parts.add({
            'role': 'model',
            'parts': [
              {'text': m.replaceFirst("Synciee:", "").trim()},
            ],
          });
        }
      }
    }

    // ✅ Add current user prompt as the last item
    parts.add({
      'role': 'user',
      'parts': [
        {'text': prompt},
      ],
    });

    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'contents': parts}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];
      return text;
    } else {
      print('Gemini API error: ${response.body}');
      return 'Sorry, something went wrong.';
    }
  }
}
