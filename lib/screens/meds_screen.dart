// lib/screens/meds_screen.dart
import 'package:flutter/material.dart';

class MedsScreen extends StatelessWidget {
  const MedsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medications')),
      body: const Center(child: Text('Medications Screen Content')),
    );
  }
}
