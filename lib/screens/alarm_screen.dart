import 'package:firstapp/screens/frequency_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../static/wavy_background.dart';
import 'date_screen.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final _intakeTimes = <TimeOfDay?>[null, null, null];
  final _ampmValues = ['AM', 'AM', 'AM'];
  final _hourControllers = List.generate(3, (_) => TextEditingController(text: '08'));
  final _minuteControllers = List.generate(3, (_) => TextEditingController(text: '00'));

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
    return Card(
      color: Colors.grey[50],
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time for ${['First', 'Second', 'Third'][i]} Intake',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildTimeTextField(_hourControllers[i], 'HH'),
                const SizedBox(width: 6),
                const Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                _buildTimeTextField(_minuteControllers[i], 'MM'),
                const SizedBox(width: 16),
                _buildAmPmDropdown(i),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _selectTime(ctx, i),
                icon: const Icon(Icons.access_time),
                label: const Text('Pick Time'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTextField(TextEditingController controller, String hint) {
    return SizedBox(
      width: 64,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        ),
      ),
    );
  }

  Widget _buildAmPmDropdown(int i) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: _ampmValues[i],
        underline: const SizedBox(),
        items: ['AM', 'PM'].map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _ampmValues[i] = newValue;
              int hour = int.parse(_hourControllers[i].text);
              if (newValue == 'PM' && hour < 12) hour += 12;
              if (newValue == 'AM' && hour == 12) hour = 0;
              _intakeTimes[i] = (_intakeTimes[i] ?? TimeOfDay.now()).replacing(hour: hour);
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FrequencyScreen())),
        ),
        title: const Text('Intake Time'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const WavyBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildTimeInput(context, 0),
                  _buildTimeInput(context, 1),
                  _buildTimeInput(context, 2),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DateScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
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
