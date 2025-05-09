import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY']!;
  static final String _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  static Future<String> getGeminiResponse(String prompt, {List<String>? memory}) async {
    final context = memory != null ? memory.join('\n') : '';
    final medicalPrompt = """
You are Synciee, a helpful and knowledgeable medical assistant. You can answer questions about prescriptions, symptoms, medications, and general health advice. Avoid giving dangerous or unverified advice.

$context
User: $prompt
Synciee:""";

    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': medicalPrompt}
            ]
          }
        ]
      }),
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