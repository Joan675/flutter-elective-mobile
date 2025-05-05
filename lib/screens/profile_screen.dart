// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'meds_screen.dart';
import 'logs_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "John Doe";
  String _address = "123 Main St,";
  int _age = 30;
  String _contactNumber = "555-123-4567";
  String _emailAddress = "john.doe@example.com";
  DateTime _birthDate = DateTime(1993, 5, 15);
  late String _formattedBirthDate;

  final List<Map<String, String>> _appointments = [];

  @override
  void initState() {
    super.initState();
    _formattedBirthDate = DateFormat('MMMM dd, yyyy').format(_birthDate);
  }

  void _editProfile() async {
    final result = await showDialog(
      context: context,
      builder: (_) => EditProfileDialog(
        name: _name,
        address: _address,
        age: _age,
        contactNumber: _contactNumber,
        emailAddress: _emailAddress,
        birthDate: _birthDate,
      ),
    );
    if (result != null) {
      setState(() {
        _name = result['name']!;
        _address = result['address']!;
        _age = result['age'] as int;
        _contactNumber = result['contactNumber']!;
        _emailAddress = result['emailAddress']!;
        _birthDate = result['birthDate'] as DateTime;
        _formattedBirthDate = DateFormat('MMMM dd, yyyy').format(_birthDate);
      });
    }
  }

  void _addAppointment() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AddAppointmentDialog(),
    );
    if (result != null) {
      setState(() => _appointments.add(result));
    }
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 18)),
        ]),
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, String> appt) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Time: ${appt['time'] ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
          Text("Date: ${appt['date'] ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
          Text("Reason: ${appt['reason'] ?? 'N/A'}", style: const TextStyle(fontSize: 16)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(alignment: Alignment.topLeft, child: IconButton(icon: const Icon(Icons.menu), onPressed: () {})),
            const SizedBox(height: 16),
            const Center(child: CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://via.placeholder.com/100'))),
            const SizedBox(height: 16),
            _buildInfoCard(title: 'Name', content: _name),
            _buildInfoCard(title: 'Address', content: _address),
            _buildInfoCard(title: 'Age', content: _age.toString()),
            _buildInfoCard(title: 'Contact Number', content: _contactNumber),
            _buildInfoCard(title: 'Email Address', content: _emailAddress),
            _buildInfoCard(title: 'Birth Date', content: _formattedBirthDate),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _editProfile, child: const Text('Edit Profile')),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MedsScreen())),
                  style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)))),
                  child: const Text('Meds'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LogsScreen())),
                  style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)))),
                  child: const Text('Logs'),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            const Text('Appointments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_appointments.isNotEmpty)
              ..._appointments.map(_buildAppointmentCard)
            else
              const Text("No appointments added yet."),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addAppointment, child: const Text('Add Appointment')),
          ]),
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final String name, address, contactNumber, emailAddress;
  final int age;
  final DateTime birthDate;

  const EditProfileDialog({
    super.key,
    required this.name,
    required this.address,
    required this.age,
    required this.contactNumber,
    required this.emailAddress,
    required this.birthDate,
  });

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameC, _addressC, _ageC, _contactC, _emailC;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.name);
    _addressC = TextEditingController(text: widget.address);
    _ageC = TextEditingController(text: widget.age.toString());
    _contactC = TextEditingController(text: widget.contactNumber);
    _emailC = TextEditingController(text: widget.emailAddress);
    _selectedDate = widget.birthDate;
  }

  @override
  void dispose() {
    _nameC.dispose(); _addressC.dispose(); _ageC.dispose();
    _contactC.dispose(); _emailC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(children: [
          TextField(controller: _nameC, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _addressC, decoration: const InputDecoration(labelText: 'Address')),
          TextField(controller: _ageC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age')),
          TextField(controller: _contactC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Contact Number')),
          TextField(controller: _emailC, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email Address')),
          Row(children: [
            Text('Birth Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate)}'),
            IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate),
          ]),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            final age = int.tryParse(_ageC.text);
            if (_nameC.text.isEmpty || _addressC.text.isEmpty || age == null || _contactC.text.isEmpty || _emailC.text.isEmpty) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please fill in all fields with valid data.'),
                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
                ),
              );
              return;
            }
            Navigator.of(context).pop({
              'name': _nameC.text,
              'address': _addressC.text,
              'age': age,
              'contactNumber': _contactC.text,
              'emailAddress': _emailC.text,
              'birthDate': _selectedDate,
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class AddAppointmentDialog extends StatefulWidget {
  const AddAppointmentDialog({super.key});
  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final _timeC = TextEditingController();
  final _dateC = TextEditingController();
  final _reasonC = TextEditingController();
  DateTime _selDate = DateTime.now();
  TimeOfDay _selTime = TimeOfDay.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        _selDate = picked;
        _dateC.text = DateFormat('MMMM dd, yyyy').format(_selDate);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selTime);
    if (picked != null) {
      setState(() {
        _selTime = picked;
        _timeC.text = _selTime.format(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateC.text = DateFormat('MMMM dd, yyyy').format(_selDate);
    _timeC.text = _selTime.format(context);
  }

  @override
  void dispose() {
    _timeC.dispose(); _dateC.dispose(); _reasonC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Appointment'),
      content: SingleChildScrollView(
        child: Column(children: [
          TextField(
            controller: _timeC, decoration: const InputDecoration(labelText: 'Time'),
            readOnly: true, onTap: _pickTime,
          ),
          TextField(
            controller: _dateC, decoration: const InputDecoration(labelText: 'Date'),
            readOnly: true, onTap: _pickDate,
          ),
          TextField(controller: _reasonC, decoration: const InputDecoration(labelText: 'Reason for Appointment')),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            if (_timeC.text.isEmpty || _dateC.text.isEmpty || _reasonC.text.isEmpty) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please fill in all fields.'),
                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
                ),
              );
              return;
            }
            Navigator.of(context).pop({
              'time': _timeC.text,
              'date': _dateC.text,
              'reason': _reasonC.text,
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
