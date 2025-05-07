// lib/screens/frequency_screen.dart
import 'package:firstapp/screens/add_medicine_screen.dart';
import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import 'alarm_screen.dart';

class FrequencyScreen extends StatefulWidget {
  const FrequencyScreen({super.key});

  @override
  State<FrequencyScreen> createState() => _FrequencyScreenState();
}

class _FrequencyScreenState extends State<FrequencyScreen> {
  String? _selectedFrequency = 'Three times a day';
  final TextEditingController _reminderDescriptionController = TextEditingController();
  final List<String> _frequencyOptions = [
    'Once a day', 'Twice a day', 'Three times a day', 'Four times a day'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF64B5F6)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          const WavyBackground(), // 👈 Background layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How Frequent will\nyou take your\nMedication?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.3),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      value: _selectedFrequency,
                      items: _frequencyOptions
                          .map((v) => DropdownMenuItem(
                                value: v,
                                child: Text(
                                  v,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() => _selectedFrequency = v);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Frequency selected: $v')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Reminder\nDescription:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reminderDescriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    onChanged: (v) {},
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AlarmScreen()));
                    },
                    child: const Text('Next'),
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
