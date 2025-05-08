import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../storage/profile_storage.dart';
import '../static/app_sidebar.dart';
import '../static/custom_date_picker.dart';
import '../static/wavy_background.dart';
import 'logs_screen.dart';
import 'meds_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ────────────────────────────────────────────────────────────
  // Demo data (replace with your own provider / backend later)  
  // ────────────────────────────────────────────────────────────
  late String _name;
  late String _address;
  late int _age;
  late String _contactNumber;
  late String _emailAddress;
  late DateTime _birthDate;
  late String _formattedBirthDate;
  File? _avatarImage; // ← Add this line

  final List<Map<String, String>> _appointments = [];
  // ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final data = await ProfileStorage.loadProfile();
    setState(() {
      _name = data['name'];
      _address = data['address'];
      _age = data['age'];
      _contactNumber = data['contact'];
      _emailAddress = data['email'];
      _birthDate = data['birthDate'];
      _formattedBirthDate = DateFormat('MMMM dd, yyyy').format(_birthDate);

      final avatarPath = data['avatarPath'] as String?;
      if (avatarPath != null && File(avatarPath).existsSync()) {
        _avatarImage = File(avatarPath);
      }
    });
  }

  Future<void> _pickAvatarImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      // Save image to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(picked.path);
      final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');

      setState(() {
        _avatarImage = savedImage;
      });

      // Save avatar path in profile storage
      await ProfileStorage.saveProfile(
        name: _name,
        address: _address,
        age: _age,
        contact: _contactNumber,
        email: _emailAddress,
        birthDate: _birthDate,
        avatarPath: savedImage.path, // ← save path
      );
    }
  }

  void _editProfile() async {
    final result = await showDialog<Map<String, dynamic>>(
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
        _name = result['name'] as String;
        _address = result['address'] as String;
        _age = result['age'] as int;
        _contactNumber = result['contactNumber'] as String;
        _emailAddress = result['emailAddress'] as String;
        _birthDate = result['birthDate'] as DateTime;
        _formattedBirthDate = DateFormat('MMMM dd, yyyy').format(_birthDate);
      });

      // ✅ Save the updated profile locally
      await ProfileStorage.saveProfile(
        name: _name,
        address: _address,
        age: _age,
        contact: _contactNumber,
        email: _emailAddress,
        birthDate: _birthDate,
      );
    }
  }

  void _addAppointment() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const AddAppointmentDialog(),
    );

    if (result != null) {
      setState(() => _appointments.add(result));
    }
  }

  // ────────────────────────────────────────────────────────────
  // UI builders                                                
  // ────────────────────────────────────────────────────────────
  Widget _buildAppointmentCard(Map<String, String> appt) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${appt['time'] ?? 'N/A'}'),
            Text('Date: ${appt['date'] ?? 'N/A'}'),
            Text('Reason: ${appt['reason'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const WavyBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── menu icon ──────────────────────────────
                    Align(
                      alignment: Alignment.topLeft,
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── avatar ────────────────────────────────
                    Center(
                      child: GestureDetector(
                        onTap: _pickAvatarImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _avatarImage != null
                              ? FileImage(_avatarImage!)
                              : const NetworkImage('https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png') as ImageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── profile card ───────────────────────────
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Address: $_address'),
                            Text('Age: $_age'),
                            Text('Contact: $_contactNumber'),
                            Text('Email: $_emailAddress'),
                            Text('Birth Date: $_formattedBirthDate'),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _editProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF78AFC9),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Meds & Logs buttons ────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _IconCardButton(
                            icon: Icons.favorite,
                            label: 'Meds',
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MedsScreen())),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _IconCardButton(
                            icon: Icons.folder,
                            label: 'Logs',
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LogsScreen())),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Appointments header ────────────────────
                    const Text('Appointments',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    // ── Appointments container ─────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (_appointments.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('No appointments yet.'),
                            ),
                          ..._appointments.map(_buildAppointmentCard),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: _addAppointment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF78AFC9),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('Add Appointment',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Helper widget for Meds / Logs icon‑buttons
// ──────────────────────────────────────────────────────────────
class _IconCardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _IconCardButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF78AFC9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Edit Profile Dialog (unchanged except colors)                
// ──────────────────────────────────────────────────────────────
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
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController _nameC,
      _addressC,
      _ageC,
      _contactC,
      _emailC;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize controllers first with empty strings (or defaults)
    _nameC = TextEditingController();
    _addressC = TextEditingController();
    _ageC = TextEditingController();
    _contactC = TextEditingController();
    _emailC = TextEditingController();

    _loadProfile(); // Then load the values into the controllers
  }

  void _loadProfile() async {
    final data = await ProfileStorage.loadProfile();
    setState(() {
      _nameC.text = data['name'];
      _addressC.text = data['address'];
      _ageC.text = data['age'].toString();
      _contactC.text = data['contact'];
      _emailC.text = data['email'];
      _selectedDate = data['birthDate'];
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    _addressC.dispose();
    _ageC.dispose();
    _contactC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showCustomDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _save() {
    final age = int.tryParse(_ageC.text);
    if (_nameC.text.isEmpty ||
        _addressC.text.isEmpty ||
        age == null ||
        _contactC.text.isEmpty ||
        _emailC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields correctly.')));
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
  }

  Widget _buildField(String label, TextEditingController c,
      {TextInputType inputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: c,
          keyboardType: inputType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFFE0F7FA),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField('Name', _nameC),
              const SizedBox(height: 10),
              _buildField('Address', _addressC),
              const SizedBox(height: 10),
              _buildField('Age', _ageC, inputType: TextInputType.number),
              const SizedBox(height: 10),
              _buildField('Contact Number', _contactC,
                  inputType: TextInputType.phone),
              const SizedBox(height: 10),
              _buildField('Email Address', _emailC,
                  inputType: TextInputType.emailAddress),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Birth Date',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MMMM dd, yyyy').format(_selectedDate)),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF78AFC9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Add Appointment Dialog (original with style tweaks)           
// ──────────────────────────────────────────────────────────────
class AddAppointmentDialog extends StatefulWidget {
  const AddAppointmentDialog({super.key});

  @override
  State<AddAppointmentDialog> createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  TimeOfDay _time = TimeOfDay.now();
  DateTime _date = DateTime.now();
  final TextEditingController _reasonC = TextEditingController();

  void _selectTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _selectDate() async {
    final picked = await showCustomDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (_reasonC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a reason')));
      return;
    }
    Navigator.of(context).pop({
      'time': _time.format(context),
      'date': DateFormat('MMMM dd, yyyy').format(_date),
      'reason': _reasonC.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAM = _time.period == DayPeriod.am;
    final hour = _time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = _time.minute.toString().padLeft(2, '0');
    final dateChip = '${_date.month}/${_date.day}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFFE0F7FA),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Appointment Date',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Spacer(),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF78AFC9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(dateChip,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text('Enter time'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(hour,
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                          const Text(':', style: TextStyle(fontSize: 32)),
                          Text(minute,
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              _ampmChip('AM', isAM),
                              _ampmChip('PM', !isAM),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reasonC,
                decoration: InputDecoration(
                  labelText: 'Reason for Appointment',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF78AFC9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child:
                      const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ampmChip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.white : const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}