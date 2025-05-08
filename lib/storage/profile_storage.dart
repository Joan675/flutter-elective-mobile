import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileStorage {
  static Future<void> saveProfile({
    required String name,
    required String address,
    required int age,
    required String contact,
    required String email,
    required DateTime birthDate,
    String? avatarPath, // ← add this
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('address', address);
    await prefs.setInt('age', age);
    await prefs.setString('contact', contact);
    await prefs.setString('email', email);
    await prefs.setString('birthDate', birthDate.toIso8601String());
    if (avatarPath != null) {
      await prefs.setString('avatarPath', avatarPath);
    }
  }

  static Future<Map<String, dynamic>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'John Doe',
      'address': prefs.getString('address') ?? '123 Main St,',
      'age': prefs.getInt('age') ?? 30,
      'contact': prefs.getString('contact') ?? '555‑123‑4567',
      'email': prefs.getString('email') ?? 'john.doe@example.com',
      'birthDate': DateTime.tryParse(prefs.getString('birthDate') ?? '') ??
          DateTime(1993, 5, 15),
      'avatarPath': prefs.getString('avatarPath'), // ← add this
    };
  }

  static Future<void> saveAppointments(List<Map<String, String>> appointments) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(appointments); // Convert to JSON string
    await prefs.setString('appointments', encoded);
  }

  static Future<List<Map<String, String>>> loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('appointments');
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map<Map<String, String>>((dynamic item) {
      final Map<String, dynamic> raw = item as Map<String, dynamic>;
      return raw.map<String, String>(
        (key, value) => MapEntry(key, value.toString()),
      );
    }).toList();
  }
}