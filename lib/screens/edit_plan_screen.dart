import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import '../storage/medicine_plan_storage.dart';

class EditPlanScreen extends StatefulWidget {
  final String planId;
  final String medicineName;
  final String medType;
  final String frequency;
  final String reminderDesc;
  final List<bool> intakeDays;
  final List<String> alarmTimes;

  const EditPlanScreen({
    super.key,
    required this.planId,
    required this.medicineName,
    required this.medType,
    required this.frequency,
    required this.reminderDesc,
    required this.intakeDays,
    required this.alarmTimes,
  });

  @override
  State<EditPlanScreen> createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  final _descriptionController = TextEditingController();
  String? _selectedFrequency;
  late List<bool> _selectedDays;
  List<String> _alarmTimes = [];

  final List<String> _frequencyOptions = [
    'Once a day',
    'Twice a day',
    'Three times a day',
    'Four times a day',
  ];

  final List<String> _dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  int _maxAlarmsByFrequency(String? freq) {
    switch (freq) {
      case 'Once a day':
        return 1;
      case 'Twice a day':
        return 2;
      case 'Three times a day':
        return 3;
      case 'Four times a day':
        return 4;
      default:
        return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.frequency;
    _descriptionController.text = widget.reminderDesc;
    _selectedDays = List<bool>.from(widget.intakeDays);
    _alarmTimes = List<String>.from(widget.alarmTimes);

    final max = _maxAlarmsByFrequency(_selectedFrequency);
    if (_alarmTimes.length < max) {
      _alarmTimes.addAll(List.generate(max - _alarmTimes.length, (_) => "08:00 AM"));
    } else if (_alarmTimes.length > max) {
      _alarmTimes = _alarmTimes.sublist(0, max);
    }
  }

  Future<void> _pickTime(int index) async {
    final initial = TimeOfDay(
      hour: int.parse(_alarmTimes[index].split(":")[0]),
      minute: int.parse(_alarmTimes[index].split(":")[1].split(" ")[0]),
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() => _alarmTimes[index] = picked.format(context));
    }
  }

  Future<void> _savePlan() async {
    await MedicinePlanStorage.savePlan(
      planId: widget.planId,
      medicineName: widget.medicineName,
      medType: widget.medType,
      frequency: _selectedFrequency ?? widget.frequency,
      reminderDesc: _descriptionController.text,
      intakeTimes: _alarmTimes,
      intakeDays: _selectedDays,
      startDate: DateTime.now().toIso8601String().split('T').first,
    );
    if (mounted) Navigator.pop(context);
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
          icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: _savePlan,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: Stack(
        children: [
          const WavyBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Edit Frequency",
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildCard(
                    DropdownButtonFormField<String>(
                      value: _selectedFrequency,
                      items: _frequencyOptions.map((f) =>
                        DropdownMenuItem(value: f, child: Text(f))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedFrequency = val;
                          final max = _maxAlarmsByFrequency(val);
                          if (_alarmTimes.length > max) {
                            _alarmTimes = _alarmTimes.sublist(0, max);
                          } else {
                            _alarmTimes.addAll(List.generate(max - _alarmTimes.length, (_) => "08:00 AM"));
                          }
                        });
                      },
                      decoration: const InputDecoration(border: InputBorder.none),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text("Reminder Description", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _buildCard(
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'e.g. Take before meals',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text("Select Intake Days", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: List.generate(7, (i) {
                      return FilterChip(
                        label: Text(_dayLabels[i]),
                        selected: _selectedDays[i],
                        onSelected: (val) => setState(() => _selectedDays[i] = val),
                        selectedColor: Colors.blueGrey,
                      );
                    }),
                  ),

                  const SizedBox(height: 24),
                  Text("Alarm Times", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ..._alarmTimes.asMap().entries.map((entry) {
                    int index = entry.key;
                    String time = entry.value;
                    return _buildCard(
                      ListTile(
                        title: Text(time),
                        leading: const Icon(Icons.alarm, color: Colors.blueGrey),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _pickTime(index),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "${_alarmTimes.length} of ${_maxAlarmsByFrequency(_selectedFrequency)} alarms set",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _savePlan,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

  Widget _buildCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
