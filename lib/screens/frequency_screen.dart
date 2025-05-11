import 'package:flutter/material.dart';
import 'package:firstapp/screens/add_medicine_screen.dart';
import '../static/wavy_background.dart';
import 'alarm_screen.dart';
import '../models/medicine.dart';

class FrequencyScreen extends StatefulWidget {
  final Medicine selectedMedicine;
  final String? existingFrequency;
  final String? existingReminder;

    const FrequencyScreen({
    super.key,
    required this.selectedMedicine,
    this.existingFrequency,
    this.existingReminder,
  });

  @override
  State<FrequencyScreen> createState() => _FrequencyScreenState();
}

class _FrequencyScreenState extends State<FrequencyScreen> {
  String? _selectedFrequency;
  final TextEditingController _reminderDescriptionController = TextEditingController();
  final List<String> _frequencyOptions = [
    'Once a day',
    'Twice a day',
    'Three times a day',
    'Four times a day',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.existingFrequency ?? 'Three times a day';
    _reminderDescriptionController.text = widget.existingReminder ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
            );
          },
        ),
        title: const Text(
          "Frequency",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          const WavyBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How often do you\ntake your medicine?',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Frequency Dropdown
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedFrequency,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: _frequencyOptions.map((v) {
                        return DropdownMenuItem<String>(
                          value: v,
                          child: Text(
                            v,
                            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedFrequency = value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Selected: $value')),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Reminder Description
                  Text(
                    'Reminder Description',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _reminderDescriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'e.g. Before lunch, take with water...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Next Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4DB1E3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 5,
                    ),
onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AlarmScreen(
        selectedMedicine: widget.selectedMedicine,
        frequency: _selectedFrequency!,
        reminderDesc: _reminderDescriptionController.text,
      ),
    ),
  );

  if (result != null && mounted) {
    setState(() {
      _selectedFrequency = result['frequency'] ?? _selectedFrequency;
      _reminderDescriptionController.text = result['reminderDesc'] ?? _reminderDescriptionController.text;
    });
  }
},
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
