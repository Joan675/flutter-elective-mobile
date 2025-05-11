import 'package:firstapp/screens/frequency_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../static/wavy_background.dart';
import 'date_screen.dart';
import '../models/medicine.dart';

class AlarmScreen extends StatefulWidget {
  final Medicine selectedMedicine;
  final String frequency;
  final String reminderDesc;

  const AlarmScreen({
    super.key,
    required this.selectedMedicine,
    required this.frequency,
    required this.reminderDesc,
  });

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}


class _AlarmScreenState extends State<AlarmScreen> {
  late List<TimeOfDay?> _intakeTimes;
  late List<String> _ampmValues;
  late List<TextEditingController> _hourControllers;
  late List<TextEditingController> _minuteControllers;

  int _getCardCountFromFrequency(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'once a day':
        return 1;
      case 'twice a day':
        return 2;
      case 'three times a day':
        return 3;
      case 'four times a day':
        return 4;
      default:
        return 1;
    }
  }

  String _ordinalLabel(int i) {
    const labels = ['First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth'];
    return i < labels.length ? labels[i] : 'Intake ${i + 1}';
  }

  @override
  void initState() {
    super.initState();
    int cardCount = _getCardCountFromFrequency(widget.frequency);
    _intakeTimes = List<TimeOfDay?>.filled(cardCount, null);
    _ampmValues = List<String>.filled(cardCount, 'AM');
    _hourControllers = List.generate(cardCount, (_) => TextEditingController(text: '08'));
    _minuteControllers = List.generate(cardCount, (_) => TextEditingController(text: '00'));
  }

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
              'Time for ${_ordinalLabel(i)} Intake',
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
              int minute = int.tryParse(_minuteControllers[i].text) ?? 0;
              _intakeTimes[i] = TimeOfDay(hour: hour, minute: minute);

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
onPressed: () {
  final formattedTimes = List<String>.generate(_intakeTimes.length, (i) {
    if (_intakeTimes[i] != null) {
      return _intakeTimes[i]!.format(context);
    }

    int hour = int.tryParse(_hourControllers[i].text) ?? 8;
    int minute = int.tryParse(_minuteControllers[i].text) ?? 0;
    String ampm = _ampmValues[i];
    if (ampm == 'PM' && hour < 12) hour += 12;
    if (ampm == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute).format(context);
  });

  Navigator.pop(context, {
    'frequency': widget.frequency,
    'reminderDesc': widget.reminderDesc,
    'intakeTimes': formattedTimes,
  });
},


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
                  ..._intakeTimes.asMap().entries.map((entry) {
                    final i = entry.key;
                    return _buildTimeInput(context, i);
                  }).toList(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB1E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 5,
                      ),
                     onPressed: () async {
  final formattedTimes = List<String>.generate(_intakeTimes.length, (i) {
    if (_intakeTimes[i] != null) {
      return _intakeTimes[i]!.format(context);
    }

    int hour = int.tryParse(_hourControllers[i].text) ?? 8;
    int minute = int.tryParse(_minuteControllers[i].text) ?? 0;
    String ampm = _ampmValues[i];

    if (ampm == 'PM' && hour < 12) hour += 12;
    if (ampm == 'AM' && hour == 12) hour = 0;

    final fallback = TimeOfDay(hour: hour, minute: minute);
    return fallback.format(context);
  });

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DateScreen(
        selectedMedicine: widget.selectedMedicine,
        frequency: widget.frequency,
        reminderDesc: widget.reminderDesc,
        intakeTimes: formattedTimes,
      ),
    ),
  );

  // ✅ If user navigates back, rehydrate intake times
  if (result != null && mounted) {
    setState(() {
      if (result['intakeTimes'] != null) {
        final intakeList = List<String>.from(result['intakeTimes']);
        for (int i = 0; i < intakeList.length; i++) {
          final split = intakeList[i].split(RegExp(r'[: ]'));
          int hour = int.parse(split[0]);
          int minute = int.parse(split[1]);
          String ampm = split[2];

          if (ampm == 'PM' && hour < 12) hour += 12;
          if (ampm == 'AM' && hour == 12) hour = 0;

          final time = TimeOfDay(hour: hour, minute: minute);
          _intakeTimes[i] = time;
          _hourControllers[i].text = time.hourOfPeriod.toString().padLeft(2, '0');
          _minuteControllers[i].text = time.minute.toString().padLeft(2, '0');
          _ampmValues[i] = time.period == DayPeriod.am ? 'AM' : 'PM';
        }
      }
    });
  }
},
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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
