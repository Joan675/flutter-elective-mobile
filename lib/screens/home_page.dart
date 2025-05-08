import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import '../static/app_sidebar.dart';
import '../storage/medicine_plan_storage.dart';
import '../models/medicine.dart';
import '../screens/edit_plan_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _savedPlans = [];

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    final plans = await MedicinePlanStorage.loadPlans();
    setState(() {
      _savedPlans = plans;
    });
  }

void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
  final intakeDays = List<bool>.from(data['intakeDays'] ?? []);
  final alarmTimes = List<String>.from(data['alarmTimes'] ?? []);
  const dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  final selectedDays = List.generate(7, (i) => intakeDays[i] ? dayLabels[i] : null)
      .whereType<String>()
      .toList();

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title + Close ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.medical_services_rounded, color: Colors.lightBlue),
                    SizedBox(width: 8),
                    Text(
                      "Prescription Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: "Close",
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Basic Info ──
            _detailRow("Name", data['medicineName']),
            _detailRow("Type", data['medType']),
            _detailRow("Frequency", data['frequency']),
            _detailRow("Description", data['reminderDesc']),
            const SizedBox(height: 12),

            // ── Days ──
            const Text("Days:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: selectedDays
                  .map((day) => Chip(
                        label: Text(day),
                        backgroundColor: Colors.lightBlue.shade50,
                        labelStyle: const TextStyle(fontSize: 13),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),

            // ── Alarm Times ──
            const Text("Alarm Times:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: alarmTimes.map((time) {
                return Chip(
                  avatar: const Icon(Icons.alarm, size: 16, color: Colors.blueGrey),
                  label: Text(time),
                  backgroundColor: Colors.teal.shade50,
                  labelStyle: const TextStyle(fontSize: 13),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Bottom Buttons (Edit + Delete) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await MedicinePlanStorage.deletePlan(data['planId']);
                    await _loadPlan();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  label: const Text("Delete"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();

                      final medicine = Medicine(
                        name: data['medicineName'] ?? '',
                        medtype: data['medType'] ?? '',
                        brand: 'N/A',
                        quantity: 1,
                        stock: 1.0,
                        uses: 'N/A',
                        sideEffects: 'N/A',
                        ingredients: 'N/A',
                        directions: 'N/A',
                        warnings: 'N/A',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPlanScreen(
                            planId: data['planId'],
                            medicineName: data['medicineName'],
                            medType: data['medType'],
                            frequency: data['frequency'],
                            reminderDesc: data['reminderDesc'],
                            intakeDays: List<bool>.from(data['intakeDays'] ?? []),
                            alarmTimes: List<String>.from(data['alarmTimes'] ?? []),
                          ),
                        ),
                      ).then((_) => _loadPlan()); // ← refresh after return
                    },
                    icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                    label: const Text("Edit"),
                    style: TextButton.styleFrom(foregroundColor: Colors.orangeAccent),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF81D4FA),
        elevation: 0,
        title: const Text("Reminders"),
        iconTheme: const IconThemeData(color: Colors.black87),
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
                  const SectionHeader(title: "📋 My Prescriptions"),
                  const SizedBox(height: 8),
                    if (_savedPlans.isNotEmpty)
                      Column(
                        children: _savedPlans.map((plan) {
                          return PrescriptionCard(
                            isInfoMode: true,
                            medicineName: plan['medicineName'],
                            medType: plan['medType'],
                            frequency: plan['frequency'],
                            description: plan['reminderDesc'],
                            intakeDays: List<bool>.from(plan['intakeDays'] ?? []),
                            alarmTimes: List<String>.from(plan['alarmTimes'] ?? []),
                            onTap: () => _showDetailsDialog(context, plan),
                          );
                        }).toList(),
                      )
                    else
                      const Text(
                        'No saved prescriptions.',
                        style: TextStyle(color: Colors.grey),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final bool isInfoMode;
  final bool isLast;
  final String? medicineName;
  final String? medType;
  final String? frequency;
  final String? description;
  final List<bool>? intakeDays;
  final List<String>? alarmTimes; // new
  final VoidCallback? onTap; // new

  const PrescriptionCard({
    super.key,
    required this.isInfoMode,
    this.isLast = false,
    this.medicineName,
    this.medType,
    this.frequency,
    this.description,
    this.intakeDays,
    this.alarmTimes,
    this.onTap,
  });

  String _formatDays(List<bool> days) {
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<String> selected = [];
    for (int i = 0; i < days.length; i++) {
      if (days[i]) selected.add(labels[i]);
    }
    return selected.isEmpty ? 'No days selected' : selected.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isInfoMode ? Colors.white : Colors.blue.shade50;
    final shadowColor = Colors.blue.shade100;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: shadowColor,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isInfoMode)
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    const Text("Jun 10, 2024", style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("9:41 AM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              if (!isInfoMode) const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.medical_services_rounded, size: 40, color: Colors.lightBlue),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicineName ?? "Prescription Name",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (medType != null)
                              Chip(label: Text(medType!), backgroundColor: Colors.blue.shade50),
                            if (frequency != null)
                              Chip(label: Text(frequency!), backgroundColor: Colors.teal.shade50),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (intakeDays != null)
                          Text(
                            "Days: ${_formatDays(intakeDays!)}",
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          description ?? "No description provided.",
                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      if (isInfoMode) ...[
                        Tooltip(
                          message: 'More Info',
                          child: const Icon(Icons.info_outline, color: Colors.lightBlue),
                        ),
                      ] else ...[
                        IconButton(
                          icon: Icon(
                            isLast ? Icons.close_rounded : Icons.check_circle_outline,
                            color: isLast ? Colors.redAccent : Colors.green,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _detailRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(value?.isNotEmpty == true ? value! : "N/A"),
        ),
      ],
    ),
  );
}
