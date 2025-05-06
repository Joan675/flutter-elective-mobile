import 'package:flutter/material.dart';
import '../static/wavy_background.dart';
import '../static/app_sidebar.dart'; // ← import sidebar
import 'frequency_screen.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final List<String> _labels = const [
    'Liquid',
    'Capsule',
    'Tablet',
    'Drops',
    'Inhalers',
    'Injections',
    'Patches',
  ];

  int _selectedIndex = 1; // “Capsule” pre‑selected

  final List<Map<String, String>> _medicines = [];
  final TextEditingController _searchController = TextEditingController();

  void _addMedicine() {
    setState(() {
      _medicines.add({
        'name': 'Medicine ${_medicines.length + 1}',
        'brand': 'Brand',
        'uses': 'Lorem ipsum',
        'sideEffects': 'Lorem ipsum',
        'activeIngredients': 'Lorem ipsum',
        'directions': 'Lorem ipsum',
        'warnings': 'Lorem ipsum',
        'quantity': '',
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppSidebar(), // ← sidebar added
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Add Medicine'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const WavyBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(labelText: 'Search Medicine'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 14,),
                  SizedBox(
                    height: 42,                               // keeps the row a single line
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          _labels.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildLabelChip(
                              _labels[i],
                              i == _selectedIndex,
                              onTap: () => setState(() => _selectedIndex = i),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._medicines.map((m) => _buildMedicineCard(_medicines.indexOf(m))),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addMedicine,
                    child: const Text('Add Medicine'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Updated builder: look & feel mimics the screenshot
  Widget _buildLabelChip(String label, bool selected,
      {required VoidCallback onTap}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.blue.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 16, color: Colors.black87),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    }

  Widget _buildMedicineCard(int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _medicines[index]['name'],
              decoration: const InputDecoration(labelText: 'Medicine Name'),
              onChanged: (v) => _medicines[index]['name'] = v,
            ),
            const Text('Brand: Lorem ipsum'),
            const Text('Uses: Lorem ipsum'),
            const Text('Side Effects: Lorem ipsum'),
            const Text('Active Ingredients: Lorem ipsum'),
            const Text('Directions: Lorem ipsum'),
            const Text('Warnings: Lorem ipsum'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Input Quantity'),
                    onChanged: (v) => _medicines[index]['quantity'] = v,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if ((_medicines[index]['quantity'] ?? '').isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a quantity.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FrequencyScreen()));
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
}