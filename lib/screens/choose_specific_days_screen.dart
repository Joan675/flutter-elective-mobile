// lib/screens/choose_specific_days_screen.dart
import 'package:flutter/material.dart';

class ChooseSpecificDaysScreen extends StatefulWidget {
  const ChooseSpecificDaysScreen({super.key});
  @override
  _ChooseSpecificDaysScreenState createState() => _ChooseSpecificDaysScreenState();
}

class _ChooseSpecificDaysScreenState extends State<ChooseSpecificDaysScreen> {
  final List<bool> _selectedDays = List.filled(7, false);
  DateTime _selectedDate = DateTime.now();

  void _toggleDay(int i) => setState(() => _selectedDays[i] = !_selectedDays[i]);

  Future<void> _selectDate(BuildContext ctx) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _getSelectedDaysString() {
    const names = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    return [for(int i=0;i<7;i++) if(_selectedDays[i]) names[i]].join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Choose Specific Days'),
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFF0F4C3)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              for (int i = 0; i < 7; i++)
                GestureDetector(
                  onTap: () => _toggleDay(i),
                  child: Container(
                    width: 40, height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedDays[i] ? Colors.blue : Colors.grey[300],
                    ),
                    child: Text(
                      ['S','M','T','W','T','F','S'][i],
                      style: TextStyle(fontSize: 18, color: _selectedDays[i] ? Colors.white : Colors.black),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 12),
            Text('Selected Days: ${_getSelectedDaysString()}'),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Start Date'),
                    Text('${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
