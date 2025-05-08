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
    _loadAppointments(); // ← Load separately
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

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(RegExp(r'[: ]'));
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final period = parts[2].toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _loadAppointments() async {
    final loadedAppointments = await ProfileStorage.loadAppointments();

    // Sort by date and time
    loadedAppointments.sort((a, b) {
      final dateA = DateTime.parse(a['date']!);
      final dateB = DateTime.parse(b['date']!);

      if (dateA.isBefore(dateB)) return -1;
      if (dateA.isAfter(dateB)) return 1;

      // If same date, sort by time
      final timeA = _parseTimeOfDay(a['time']!);
      final timeB = _parseTimeOfDay(b['time']!);
      return timeA.hour.compareTo(timeB.hour) != 0
          ? timeA.hour.compareTo(timeB.hour)
          : timeA.minute.compareTo(timeB.minute);
    });

    setState(() {
      _appointments.clear();
      _appointments.addAll(loadedAppointments);
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

  void _sortAppointments() {
    _appointments.sort((a, b) {
      final dateA = DateTime.parse(a['date']!);
      final dateB = DateTime.parse(b['date']!);

      if (dateA.isBefore(dateB)) return -1;
      if (dateA.isAfter(dateB)) return 1;

      // If same date, sort by time
      final timeA = _parseTimeOfDay(a['time']!);
      final timeB = _parseTimeOfDay(b['time']!);
      return timeA.hour.compareTo(timeB.hour) != 0
          ? timeA.hour.compareTo(timeB.hour)
          : timeA.minute.compareTo(timeB.minute);
    });
  }

  void _addAppointment({Map<String, String>? existingAppointment, int? index}) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddAppointmentDialog(
        initialData: existingAppointment,
      ),
    );

    if (result != null) {
      // Handle deletion
      if (result['deleted'] == true && index != null) {
        setState(() {
          _appointments.removeAt(index);
          _sortAppointments();
        });
      }
      // Handle save or new
      else if (result.containsKey('date') && result.containsKey('time')) {
        setState(() {
          if (index != null) {
            _appointments[index] = {
              'date': result['date'],
              'time': result['time'],
              'reason': result['reason'],
            };
          } else {
            _appointments.add({
              'date': result['date'],
              'time': result['time'],
              'reason': result['reason'],
            });
          }
          _sortAppointments();
        });
      }

      await ProfileStorage.saveAppointments(_appointments);
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Color(0xFF78AFC9)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, String> appt, int index) {
    final prettyDate = DateFormat('MMMM dd, yyyy').format(DateTime.parse(appt['date']!));
    final time = appt['time'] ?? 'N/A';
    final reason = appt['reason'] ?? 'No reason provided';

    return GestureDetector(
      onTap: () => _addAppointment(existingAppointment: appt, index: index),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 📅 icon section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF78AFC9).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_today, color: Color(0xFF78AFC9), size: 28),
              ),
              const SizedBox(width: 16),
              // Text info section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prettyDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(time, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(reason, style: const TextStyle(color: Colors.black87)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Edit icon
              Icon(Icons.edit, color: Colors.grey.shade600),
            ],
          ),
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
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                            const SizedBox(height: 12),
                            _buildDetailRow(Icons.home, 'Address', _address),
                            _buildDetailRow(Icons.calendar_today, 'Age', '$_age'),
                            _buildDetailRow(Icons.phone, 'Contact', _contactNumber),
                            _buildDetailRow(Icons.email, 'Email', _emailAddress),
                            _buildDetailRow(Icons.cake, 'Birth Date', _formattedBirthDate),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: _editProfile,
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF78AFC9),
                                  foregroundColor: Colors.white,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          ..._appointments.asMap().entries.map((entry) {
                            return _buildAppointmentCard(entry.value, entry.key);
                          }),
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(width: 15),
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    backgroundColor: Colors.white,
    elevation: 8,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ─────────────────────────────────────
            Row(
              children: const [
                Icon(Icons.edit, color: Color(0xFF78AFC9)),
                SizedBox(width: 8),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Input Fields ──────────────────────────────
            _buildField('Name', _nameC),
            const SizedBox(height: 12),
            _buildField('Address', _addressC),
            const SizedBox(height: 12),
            _buildField('Age', _ageC, inputType: TextInputType.number),
            const SizedBox(height: 12),
            _buildField('Contact Number', _contactC, inputType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildField('Email Address', _emailC, inputType: TextInputType.emailAddress),
            const SizedBox(height: 12),

            // ── Date Picker ───────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Birth Date',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey[800])),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM dd, yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF78AFC9)),
                  ],
                ),
              ),
            ),

            // ── Submit Button ─────────────────────────────
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, size: 18),
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF78AFC9),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                label: const Text('Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
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
  final Map<String, String>? initialData;

  const AddAppointmentDialog({super.key, this.initialData});

  @override
  State<AddAppointmentDialog> createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  late TimeOfDay _time;
  late DateTime _date;
  late TextEditingController _reasonC;

  @override
  void initState() {
    super.initState();
    _reasonC = TextEditingController();
    _time = TimeOfDay.now();
    _date = DateTime.now();

    if (widget.initialData != null) {
      _reasonC.text = widget.initialData!['reason'] ?? '';
      _date = DateTime.parse(widget.initialData!['date']!);
      final rawTime = widget.initialData!['time']!;
      final parts = rawTime.split(RegExp(r'[: ]'));
      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = parts[2].toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      _time = TimeOfDay(hour: hour, minute: minute);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a reason')));
      return;
    }

    Navigator.of(context).pop({
      'time': _time.format(context),
      'date': _date.toIso8601String(),
      'reason': _reasonC.text,
    });
  }

  void _delete() {
    Navigator.of(context).pop({'deleted': true});
  }

  @override
  Widget build(BuildContext context) {
    final isAM = _time.period == DayPeriod.am;
    final hour = _time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = _time.minute.toString().padLeft(2, '0');
    final dateDisplay = DateFormat('MMMM dd, yyyy').format(_date);
    final isEditMode = widget.initialData != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: Color(0xFF78AFC9)),
                const SizedBox(width: 8),
                Text(
                  isEditMode ? 'Edit Appointment' : 'Add Appointment',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Date', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateDisplay, style: const TextStyle(fontSize: 15)),
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF78AFC9)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Time', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(hour, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const Text(':', style: TextStyle(fontSize: 32)),
                    Text(minute, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        _ampmChip('AM', isAM),
                        _ampmChip('PM', !isAM),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Reason', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _reasonC,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'E.g. Regular check-up',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                if (isEditMode)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _delete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (isEditMode) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle),
                    label: Text(isEditMode ? 'Save Changes' : 'Confirm Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF78AFC9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
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