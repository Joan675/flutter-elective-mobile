import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import '../static/app_sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
        title: Text("Reminders"),
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
                  ...List.generate(3, (index) => PrescriptionCard(isInfoMode: true)),
                  const SizedBox(height: 24),
                  const SectionHeader(title: "📚 Prescriptions Log"),
                  const SizedBox(height: 8),
                  ...List.generate(3, (index) => PrescriptionCard(isInfoMode: false, isLast: index == 2)),
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

  const PrescriptionCard({
    super.key,
    required this.isInfoMode,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isInfoMode ? Colors.white : Colors.blue[50];
    final shadowColor = isInfoMode ? Colors.blue[100]! : Colors.lightBlue[100]!;

    return Card(
      elevation: 3,
      shadowColor: shadowColor,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isInfoMode)
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  const Text("Jun 10, 2024", style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text("9:41 AM", style: TextStyle(fontSize: 12)),
                  ),
                ],
              )
            else
              const Align(
                alignment: Alignment.centerRight,
                child: Text("9:41 AM", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.medical_services_outlined, size: 40, color: Colors.lightBlue),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Prescription Name",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text("Prescription Details",
                          style: TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ),
                if (isInfoMode) ...[
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.orangeAccent),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.lightBlue),
                    onPressed: () {},
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
      ),
    );
  }
}
