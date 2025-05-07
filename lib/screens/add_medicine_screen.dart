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

  @override
  void initState() {
    super.initState();
    _medicines.addAll(List.generate(3, (i) => {
      'name': 'Medicine ${i + 1}',
      'brand': 'Brand',
      'uses': 'Lorem ipsum',
      'sideEffects': 'Lorem ipsum',
      'activeIngredients': 'Lorem ipsum',
      'directions': 'Lorem ipsum',
      'warnings': 'Lorem ipsum',
      'quantity': '',
    }));
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

  Widget _buildInfoText(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$label: Lorem Ipsum',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMedicineCard(int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _medicines[index]['name'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoText('Brand'),
            _buildInfoText('Uses'),
            _buildInfoText('Side Effects'),
            _buildInfoText('Active Ingredients'),
            _buildInfoText('Directions'),
            _buildInfoText('Warnings'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FrequencyScreen()));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  backgroundColor: Colors.lightBlue.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}