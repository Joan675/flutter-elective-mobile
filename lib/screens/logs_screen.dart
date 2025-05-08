import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import '../static/app_sidebar.dart';
import '../storage/medicine_plan_storage.dart';
import '../models/medicine.dart';
import 'home_page.dart'; // for SectionHeader and PrescriptionCard

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<Map<String, dynamic>> _plans = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final loaded = await MedicinePlanStorage.loadPlans();
    setState(() => _plans = loaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF81D4FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Prescriptions Log",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          const WavyBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (_plans.isEmpty)
                    const Text("No logs yet.", style: TextStyle(color: Colors.grey)),
                  ..._plans.map((plan) => PrescriptionCard(
                        isInfoMode: false,
                        medicineName: plan['medicineName'],
                        medType: plan['medType'],
                        frequency: plan['frequency'],
                        description: plan['reminderDesc'],
                        intakeDays: List<bool>.from(plan['intakeDays'] ?? []),
                        alarmTimes: List<String>.from(plan['alarmTimes'] ?? []),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}