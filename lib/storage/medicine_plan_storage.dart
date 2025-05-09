// Enhanced MedicinePlanStorage for multiple reminders
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MedicinePlanStorage {
  static const _storageKey = 'medicinePlans';

  /// Save a new medicine plan with a unique ID
  static Future<void> savePlan({
    required String medicineName,
    required String medType,
    required String frequency,
    required String reminderDesc,
    required List<String> intakeTimes,
    required List<bool> intakeDays,
    required String startDate,
    String? planId, // Optional: used for editing existing plans
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allPlans = prefs.getStringList(_storageKey) ?? [];

    final String id = planId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final Map<String, dynamic> newPlan = {
      'planId': id,
      'medicineName': medicineName,
      'medType': medType,
      'frequency': frequency,
      'reminderDesc': reminderDesc,
      'alarmTimes': intakeTimes,
      'intakeDays': intakeDays,
      'startDate': startDate,
    };

    // If editing existing plan
    if (planId != null) {
      allPlans.removeWhere((p) => jsonDecode(p)['planId'] == planId);
    }

    allPlans.add(jsonEncode(newPlan));
    await prefs.setStringList(_storageKey, allPlans);
  }

  /// Load all saved plans
  static Future<List<Map<String, dynamic>>> loadPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> planList = prefs.getStringList(_storageKey) ?? [];

    return planList.map((planJson) {
      final data = jsonDecode(planJson);
      return {
        'planId': data['planId'],
        'medicineName': data['medicineName'],
        'medType': data['medType'],
        'frequency': data['frequency'],
        'reminderDesc': data['reminderDesc'],
        'alarmTimes': List<String>.from(data['alarmTimes']),
        'intakeDays': List<bool>.from(data['intakeDays']),
        'startDate': data['startDate'],
      };
    }).toList();
  }

  /// Delete a specific plan by planId
  static Future<void> deletePlan(String planId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allPlans = prefs.getStringList(_storageKey) ?? [];
    allPlans.removeWhere((p) => jsonDecode(p)['planId'] == planId);
    await prefs.setStringList(_storageKey, allPlans);
  }

  /// Clear all plans
  static Future<void> clearAllPlans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}