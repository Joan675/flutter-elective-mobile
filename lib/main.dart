import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Added container for the gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA), // Light cyan
              Color(0xFFF0F4C3), // Light yellow-ish
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Heart with bell icon
                const Stack(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 100.0,
                      color: Color(0xFF4FC3F7), // Light blue
                    ),
                    Positioned(
                      top: 20, // Adjust position as needed
                      left: 20,
                      child: Icon(
                        Icons.notifications,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                // Text elements
                const Text(
                  "Take your",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400, //normal
                    color: Color(0xFF00897B), //dark cyan
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Medicine",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400, //normal
                    color: Color(0xFF00897B),//dark cyan
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Responsibly now with",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400, //normal
                    color: Color(0xFF00897B), //dark cyan
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "MediaSync!",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700, //bold
                    color: Color(0xFF00897B), //dark cyan
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48.0),
                // Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement navigation to the next screen
                    ('Start Being Responsible button pressed!');
                    // Example of navigating to a new screen:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NextScreen(), // Replace NextScreen()
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FC3F7), // Light blue
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 30.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    "Start Being Responsible",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example of a placeholder for the next screen.  Replace this with your actual next screen.
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Screen'),
      ),
      body: const Center(
        child: Text('This is the next screen after the splash screen.'),
      ),
    );
  }
}









  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Medicine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AddMedicineScreen(),
    );
  }


class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  _AddMedicineScreenState createState() {
    return _AddMedicineScreenState();
  }// Made the state class public
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {// Made the state class public
  // List to hold medicine data
  final List<Map<String, String>> _medicines = [];
  final TextEditingController _searchController = TextEditingController();

  // Function to add a new medicine entry
  void _addMedicine() {
    setState(() {
      _medicines.add({
        'name': 'Medicine ${_medicines.length + 1}', // Default name
        'brand': 'Brand',
        'uses': 'Lorem ipsum',
        'sideEffects': 'Lorem ipsum',
        'activeIngredients': 'Lorem ipsum',
        'directions': 'Lorem ipsum',
        'warnings': 'Lorem ipsum',
        'quantity': '', // Initialize quantity
      });
    });
  }

  // Function to build medicine card
  Widget _buildMedicineCard(int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: _medicines[index]['name'],
              decoration: const InputDecoration(labelText: 'Medicine Name'),
              onChanged: (value) {
                _medicines[index]['name'] = value;
              },
            ),
            const Text('Brand: Lorem ipsum'), // Static text
            const Text('Uses: Lorem ipsum'), // Static text
            const Text('Side Effects: Lorem ipsum'), // Static text
            const Text('Active Ingredients: Lorem ipsum'),  // Static text
            const Text('Directions: Lorem ipsum'),  // Static text
            const Text('Warnings: Lorem ipsum'),    // Static text
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Input Quantity'),
                    onChanged: (value) {
                      _medicines[index]['quantity'] = value;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add functionality
                    ('Add button clicked for ${_medicines[index]['name']}');
                    if (_medicines[index]['quantity'] == null ||
                        _medicines[index]['quantity']!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a quantity.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return; // Stop if quantity is not provided.
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Added ${_medicines[index]['quantity']} of ${_medicines[index]['name']}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Implement menu functionality
            ('Menu button clicked');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Menu functionality not implemented yet.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        title: const Text('Add Medicine'),
        backgroundColor: Colors.lightBlue[50], // Approximate background color
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA), // Light cyan
              Color(0xFFF0F4C3), // Light yellow-ish
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Search Medicine Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search Medicine',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      // TODO: Implement search clear
                      ('Clear search');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              // Label Chips
              Wrap(
                spacing: 8.0,
                children: [
                  _buildLabelChip('Label 1', true), // First label is selected.
                  _buildLabelChip('Label 2', false),
                  _buildLabelChip('Label 3', false),
                  _buildLabelChip('Label 4', false),
                  _buildLabelChip('Label 5', false),
                ],
              ),
              const SizedBox(height: 20.0),
              // Medicine Cards
              ..._medicines.map((medicine) {
                final index = _medicines.indexOf(medicine);
                return _buildMedicineCard(index);
              }),
              const SizedBox(height: 20.0),
              // Add Medicine Button
              ElevatedButton(
                onPressed: () {
                  _addMedicine();
                },
                child: const Text('Add Medicine'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build label chips
  Widget _buildLabelChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement label selection
        ('$label selected: $selected');
      },
      backgroundColor: Colors.grey[300], // Default background color
      selectedColor: Colors.blue[200], // Color when selected
    );
  }
}












@override
Widget buildV2(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Frequency Screen',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF64B5F6),
        ),
        titleMedium: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF64B5F6),
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: Colors.grey,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF90CAF9),
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ),
    home: const FrequencyScreen(),
  );
}




class FrequencyScreen extends StatefulWidget {
  const FrequencyScreen({super.key});


  @override
  State<FrequencyScreen> createState() => _FrequencyScreenState();
}


class _FrequencyScreenState extends State<FrequencyScreen> {
  String? _selectedFrequency = 'Three times a day';
  final TextEditingController _reminderDescriptionController = TextEditingController();
  final List<String> _frequencyOptions = ['Once a day', 'Twice a day', 'Three times a day', 'Four times a day'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF64B5F6)),
          onPressed: () {
            // Implement back navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Back Button Clicked')),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'How Frequent will\nyou take your\nMedication?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                value: _selectedFrequency,
                items: _frequencyOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFrequency = newValue;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Frequency selected: $newValue')),
                  );
                },
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              'Reminder\nDescription:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _reminderDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16.0),
              ),
              onChanged: (value) {
                // Implement description change logic
                ('Description changed to: $value');
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Implement next button action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Next Button Clicked')),
                );
                ('Selected Frequency: $_selectedFrequency');
                ('Reminder Description: ${_reminderDescriptionController.text}');
                // Navigate to the next screen
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FB),
    );
  }
}








class IntakeTimeScreen extends StatefulWidget {
  const IntakeTimeScreen({super.key});

  @override
  _IntakeTimeScreenState createState() => _IntakeTimeScreenState();
}

class _IntakeTimeScreenState extends State<IntakeTimeScreen> {
  // Store the selected times
  final _intakeTimes = <TimeOfDay?>[null, null, null];
  final List<String> _ampmValues = ['AM', 'AM', 'AM']; // Store AM/PM for each time
  final List<TextEditingController> _hourControllers = [
    TextEditingController(text: '20'),
    TextEditingController(text: '20'),
    TextEditingController(text: '20'),
  ];
  final List<TextEditingController> _minuteControllers = [
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
  ];

  // Function to show the time picker and update the selected time
  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _intakeTimes[index] ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _intakeTimes[index] = pickedTime;
        //update the text controllers
        _hourControllers[index].text =
            pickedTime.hourOfPeriod.toString().padLeft(2, '0');
        _minuteControllers[index].text =
            pickedTime.minute.toString().padLeft(2, '0');
        _ampmValues[index] = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
      });
    }
  }

  // Function to build the time input section
  Widget _buildTimeInput(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Enter time of ${index == 0 ? 'First' : index == 1 ? 'Second' : 'Third'} Intake',
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: <Widget>[
              SizedBox(
                width: 50,
                child: TextField(
                  controller: _hourControllers[index],
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'HH',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      int? hour = int.tryParse(value);
                      if (hour != null && hour >= 1 && hour <= 12) {
                        _intakeTimes[index] = _intakeTimes[index]?.replacing(
                          hour: hour,
                        );
                      }
                    }
                  },
                ),
              ),
              const Text(
                ' : ',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: _minuteControllers[index],
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'MM',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      int? minute = int.tryParse(value);
                      if (minute != null && minute >= 0 && minute <= 59) {
                        _intakeTimes[index] = _intakeTimes[index]?.replacing(
                          minute: minute,
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 12.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _ampmValues[index] =
                    _ampmValues[index] == 'AM' ? 'PM' : 'AM';
                    //update the timeOfDay
                    int hour = int.parse(_hourControllers[index].text);
                    if (_ampmValues[index] == 'PM' && hour < 12) {
                      hour += 12;
                    } else if (_ampmValues[index] == 'AM' && hour == 12) {
                      hour = 0;
                    }

                    _intakeTimes[index] = _intakeTimes[index]?.replacing(
                      hour: hour,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: _ampmValues[index] == 'AM'
                        ? Colors.blue[100]
                        : Colors.grey[300],
                  ),
                  child: Text(
                    _ampmValues[index],
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: () => _selectTime(context, index),
            child: const Text('Pick Time'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Intake Time'),
        backgroundColor: Colors.lightBlue[50], // Approximate background color
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA), // Light cyan
              Color(0xFFF0F4C3), // Light yellow-ish
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildTimeInput(context, 0),
              const SizedBox(height: 16.0),
              _buildTimeInput(context, 1),
              const SizedBox(height: 16.0),
              _buildTimeInput(context, 2),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement navigation to the next screen
                  ('Next button clicked');
                  ('Intake Times: $_intakeTimes');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NextScreen(), // Replace NextScreen()
                    ),
                  );
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

// Placeholder for the next screen









class ChooseSpecificDaysScreen extends StatefulWidget {
  const ChooseSpecificDaysScreen({super.key});

  @override
  _ChooseSpecificDaysScreenState createState() =>
      _ChooseSpecificDaysScreenState();
}

class _ChooseSpecificDaysScreenState extends State<ChooseSpecificDaysScreen> {
  // Store the selected days
  final List<bool> _selectedDays = [false, false, false, false, false, false, false]; //
  DateTime _selectedDate = DateTime.now(); // Store the selected date

  // Function to handle day selection
  void _toggleDay(int index) {
    setState(() {
      _selectedDays[index] = !_selectedDays[index];
    });
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to build day buttons
  Widget _buildDayButton(String day, int index) {
    return GestureDetector(
      onTap: () => _toggleDay(index),
      child: Container(
        width: 40.0, // Increased size for better touch interaction
        height: 40.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selectedDays[index] ? Colors.blue : Colors.grey[300],
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 18.0, // Increased font size
            color: _selectedDays[index] ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Function to get the string representation of selected days
  String _getSelectedDaysString() {
    List<String> days = [];
    if (_selectedDays[0]) days.add('Sun');
    if (_selectedDays[1]) days.add('Mon');
    if (_selectedDays[2]) days.add('Tue');
    if (_selectedDays[3]) days.add('Wed');
    if (_selectedDays[4]) days.add('Thu');
    if (_selectedDays[5]) days.add('Fri');
    if (_selectedDays[6]) days.add('Sat');
    return days.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Choose Specific Days'),
        backgroundColor: Colors.lightBlue[50], // Approximate background color
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA), // Light cyan
              Color(0xFFF0F4C3), // Light yellow-ish
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Day selection buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildDayButton('S', 0),
                _buildDayButton('M', 1),
                _buildDayButton('T', 2),
                _buildDayButton('W', 3),
                _buildDayButton('T', 4),
                _buildDayButton('F', 5),
                _buildDayButton('S', 6),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              'Selected Days: ${_getSelectedDaysString()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20.0),
            // Start Date selection
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Start Date',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Done button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement done functionality
                  ('Done button clicked');
                  ('Selected Days: $_selectedDays');
                  ('Selected Date: $_selectedDate');
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}











class FindStoresScreen extends StatelessWidget {
  const FindStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Stores',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              // Add functionality for the heart icon if needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Heart icon clicked!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          // Map View Placeholder
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.map,
                  size: 100,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),

          // Store Details Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sample Store',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Sample Store Address'),
                const Text('Sample Store Contact #'),
                const Text('Sample Store Hours'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement button click functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Show Direction clicked!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Show Direction',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}








class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _message = "Welcome to the app!";

  void _incrementCounter() {
    setState(() {
      _counter++;
      _message = "You clicked the button $_counter times!";
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _message = "Counter reset!";
    });
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Snackbar: $_message"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _message,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text("Increment Counter"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showSnackBar(context),
              child: const Text("Show Snackbar"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetCounter,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Reset Counter"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}












class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample user data (replace with your actual data model)
  String _name = "John Doe";
  var _address = "123 Main St,";
  var _age = 30;
  var _contactNumber = "555-123-4567";
  var _emailAddress = "john.doe@example.com";
  DateTime _birthDate = DateTime(1993, 5, 15); // Use DateTime for birth date
  String _formattedBirthDate = DateFormat('MMMM dd, yyyy').format(DateTime(1993, 5, 15));

  // For the Add Appointment
  final List<Map<String, String>> _appointments = [];

  // Function to handle editing the profile
  void _editProfile() async {
    // Show a dialog or navigate to a new screen for editing the profile
    // This is a placeholder; you'll need to implement the actual editing UI
    final result = await showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
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
        _name = result['name'];
        _address = result['address'];
        _age = result['age'];
        _contactNumber = result['contactNumber'];
        _emailAddress = result['emailAddress'];
        _birthDate = result['birthDate'];
        _formattedBirthDate = DateFormat('MMMM dd, yyyy').format(result['birthDate']);
      });
    }
  }

  // Function to handle adding an appointment
  void _addAppointment() async {
    // Show a dialog to get appointment details
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AddAppointmentDialog(),
    );

    if (result != null) {
      setState(() {
        _appointments.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Make the content scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Top-left icon (replace with your desired icon)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.menu), // Use the menu icon
                  onPressed: () {
                    // Handle the icon button press (e.g., open a drawer)
                    // You can add your logic here
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Profile icon
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/100'), // Replace with actual image URL
                ),
              ),
              const SizedBox(height: 16),

              // User information section
              _buildInfoCard(
                title: 'Name',
                content: _name,
              ),
              _buildInfoCard(
                title: 'Address',
                content: _address,
              ),
              _buildInfoCard(
                title: 'Age',
                content: _age.toString(),
              ),
              _buildInfoCard(
                title: 'Contact Number',
                content: _contactNumber,
              ),
              _buildInfoCard(
                title: 'Email Address',
                content: _emailAddress,
              ),
              _buildInfoCard(
                title: 'Birth Date',
                content: _formattedBirthDate, // Display the formatted date
              ),

              const SizedBox(height: 10),
              // Edit Profile button
              ElevatedButton(
                onPressed: _editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color for the button
                  foregroundColor: Colors.white, // Text color
                ),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 20),

              // Meds and Logs buttons
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "Meds" button press (navigate to meds screen)
                        // Add your navigation logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MedsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text('Meds'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle "Logs" button press (navigate to logs screen)
                        // Add your navigation logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text('Logs'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Appointments section
              const Text(
                'Appointments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Display existing appointments
              if (_appointments.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _appointments.map((appointment) {
                    return _buildAppointmentCard(appointment);
                  }).toList(),
                ),
              if (_appointments.isEmpty)
                const Text("No appointments added yet."),

              const SizedBox(height: 10),
              // Add Appointment button
              ElevatedButton(
                onPressed: _addAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build info cards
  Widget _buildInfoCard({required String title, required String content}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build appointment cards
  Widget _buildAppointmentCard(Map<String, String> appointment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Time: ${appointment['time'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Date: ${appointment['date'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Reason: ${appointment['reason'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

DateFormat(String s) {
}

// Dialog for editing profile information
class EditProfileDialog extends StatefulWidget {
  final String name;
  final String address;
  final int age;
  final String contactNumber;
  final String emailAddress;
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
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _ageController;
  late TextEditingController _contactNumberController;
  late TextEditingController _emailAddressController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _addressController = TextEditingController(text: widget.address);
    _ageController = TextEditingController(text: widget.age.toString());
    _contactNumberController = TextEditingController(text: widget.contactNumber);
    _emailAddressController = TextEditingController(text: widget.emailAddress);
    _selectedDate = widget.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _contactNumberController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: _contactNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Contact Number'),
            ),
            TextField(
              controller: _emailAddressController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Birth Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate)}',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Validate the input data
            int? age = int.tryParse(_ageController.text);
            if (_nameController.text.isEmpty ||
                _addressController.text.isEmpty ||
                age == null ||
                _contactNumberController.text.isEmpty ||
                _emailAddressController.text.isEmpty) {
              // Show an error message
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content:
                  const Text('Please fill in all fields with valid data.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              return; // Stop the process
            }

            // Return the updated data
            Navigator.of(context).pop({
              'name': _nameController.text,
              'address': _addressController.text,
              'age': age,
              'contactNumber': _contactNumberController.text,
              'emailAddress': _emailAddressController.text,
              'birthDate': _selectedDate,
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Dialog for adding a new appointment
class AddAppointmentDialog extends StatefulWidget {
  const AddAppointmentDialog({super.key});

  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Initialize with current date
  TimeOfDay _selectedTime = TimeOfDay.now();    // Initialize with current time

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1), // Limit to 1 year from now
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate); //update the dateController
      });
    }
  }

  // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime.format(context); //update timeController
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('MMMM dd, yyyy').format(_selectedDate); // Initialize the date field
    _timeController.text = _selectedTime.format(context);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _dateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Appointment'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
              readOnly: true, // Make it read-only to show selected time
              onTap: () => _selectTime(context), // Open time picker on tap
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
              readOnly: true, // Make it read-only to show selected date
              onTap: () => _selectDate(context), // Open date picker on tap
            ),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason for Appointment'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_timeController.text.isEmpty ||
                _dateController.text.isEmpty ||
                _reasonController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content:
                  const Text('Please fill in all fields.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              return;
            }
            // Return the appointment details
            Navigator.of(context).pop({
              'time': _timeController.text,
              'date': _dateController.text,
              'reason': _reasonController.text,
            });
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Placeholder for the Meds Screen
class MedsScreen extends StatelessWidget {
  const MedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medications')),
      body: const Center(
        child: Text('Medications Screen Content'), // Placeholder
      ),
    );
  }
}

// Placeholder for the Logs Screen
class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logs')),
      body: const Center(
        child: Text('Logs Screen Content'), // Placeholder
      ),
    );
  }
}














  @override
  Widget chatscreen(BuildContext context) {
    return MaterialApp(
      title: 'Synciee Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  bool _isTextVisible1 = true; // Track visibility for first input
// Track visibility for second input

  void _sendMessage(String text, {String sender = 'User'}) {
    if (text.trim().isEmpty) return; // Don't send empty messages

    setState(() {
      _messages.add('$sender: $text'); // Add message with sender
      if (sender == 'User') {
        // Basic response logic (very simplified)
        if (text.toLowerCase().contains('hello')) {
          _messages.add('Synciee: Hi there!');
        } else if (text.toLowerCase().contains('how are you')) {
          _messages.add('Synciee: I\'m doing well, thank you!');
        } else {
          _messages.add('Synciee: That\'s interesting.'); // Default response
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talk to Synciee'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) => Text(_messages[index]),
              ),
            ),
          ),
          _buildInputField(
            controller: _textController1,
            icon: Icons.remove_red_eye,
            onIconPressed: () {
              setState(() {
                _isTextVisible1 = !_isTextVisible1;
              });
            },
            obscureText: _isTextVisible1,
          ),
          _buildInputField(
            controller: _textController2,
            icon: Icons.favorite_border,
            onIconPressed: () {
              setState(() {
                _sendMessage('Liked an item!'); // Add a message when heart is pressed
              });
            },
          ),
          _buildInputField(
            controller: _textController1,
            icon: Icons.remove_red_eye,
            onIconPressed: () {
              setState(() {
                _isTextVisible1 = !_isTextVisible1;
              });
            },
            obscureText: _isTextVisible1,
          ),
          _buildInputField(
            controller: _textController2,
            icon: Icons.favorite_border,
            onIconPressed: () {
              setState(() {
                _sendMessage('Liked an item!'); // Add a message when heart is pressed
              });
            },
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController1,
                    decoration: InputDecoration(
                      hintText: 'Ask Synciee',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController1.text);
                    _textController1.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required VoidCallback onIconPressed,
    bool obscureText = false,
  }) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(icon),
            onPressed: onIconPressed,
          ),
        ],
      ),
    );
  }
}