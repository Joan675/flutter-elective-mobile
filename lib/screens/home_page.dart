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
        backgroundColor: Colors.lightBlue[200],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Jun 10, 2024'),
            Text('9:41AM'),
          ],
        ),
      ),
      body: Stack(
        children: [
          const WavyBackground(), // ✅ Background layer
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: "My Prescriptions"),
                  ...List.generate(3, (index) => PrescriptionCard(isInfoMode: true)),
                  const SizedBox(height: 16),
                  const SectionHeader(title: "Prescriptions Log"),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }
}

class PrescriptionCard extends StatelessWidget {
  final bool isInfoMode;
  final bool isLast;

  const PrescriptionCard({super.key, required this.isInfoMode, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final cardColor = isInfoMode ? Colors.blue[50] : Colors.lightBlue[100];

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isInfoMode)
              Row(
                children: [
                  const Text("Jun 10, 2024"),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text("9:41AM", style: TextStyle(fontSize: 12)),
                  ),
                ],
              )
            else
              const Text("9:41AM", style: TextStyle(fontSize: 12, color: Colors.grey)),

            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.image, size: 40),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Prescription Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Prescription Details", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                if (isInfoMode) ...[
                  IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
                ] else ...[
                  IconButton(
                    icon: Icon(
                      isLast ? Icons.close : Icons.check_box,
                      color: isLast ? Colors.red : Colors.green,
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
