// lib/screens/intake_time_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'next_screen.dart';

class IntakeTimeScreen extends StatefulWidget {
  const IntakeTimeScreen({super.key});

  @override
  _IntakeTimeScreenState createState() => _IntakeTimeScreenState();
}

class _IntakeTimeScreenState extends State<IntakeTimeScreen> {
  final _intakeTimes = <TimeOfDay?>[null, null, null];
  final _ampmValues = ['AM', 'AM', 'AM'];
  final _hourControllers = [
    TextEditingController(text: '20'),
    TextEditingController(text: '20'),
    TextEditingController(text: '20'),
  ];
  final _minuteControllers = [
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
  ];

  Future<void> _selectTime(BuildContext ctx, int i) async {
    final picked = await showTimePicker(
      context: ctx,
      initialTime: _intakeTimes[i] ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _intakeTimes[i] = picked;
        _hourControllers[i].text = picked.hourOfPeriod.toString().padLeft(2, '0');
        _minuteControllers[i].text = picked.minute.toString().padLeft(2, '0');
        _ampmValues[i] = picked.period == DayPeriod.am ? 'AM' : 'PM';
      });
    }
  }

  Widget _buildTimeInput(BuildContext ctx, int i) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Enter time of ${['First','Second','Third'][i]} Intake'),
        const SizedBox(height: 12),
        Row(children: [
          SizedBox(
            width: 50,
            child: TextField(
              controller: _hourControllers[i],
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2)
              ],
              decoration: const InputDecoration(hintText: 'HH'),
            ),
          ),
          const Text(' : '),
          SizedBox(
            width: 50,
            child: TextField(
              controller: _minuteControllers[i],
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2)
              ],
              decoration: const InputDecoration(hintText: 'MM'),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _ampmValues[i] = _ampmValues[i] == 'AM' ? 'PM' : 'AM';
                int hour = int.parse(_hourControllers[i].text);
                if (_ampmValues[i] == 'PM' && hour < 12) hour += 12;
                else if (_ampmValues[i] == 'AM' && hour == 12) hour = 0;
                _intakeTimes[i] = (_intakeTimes[i] ?? TimeOfDay.now()).replacing(hour: hour);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _ampmValues[i] == 'AM' ? Colors.blue[100] : Colors.grey[300],
              ),
              child: Text(_ampmValues[i]),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: () => _selectTime(ctx, i), child: const Text('Pick Time')),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Intake Time'),
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFF0F4C3)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTimeInput(context, 0),
              const SizedBox(height: 16),
              _buildTimeInput(context, 1),
              const SizedBox(height: 16),
              _buildTimeInput(context, 2),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NextScreen()));
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
