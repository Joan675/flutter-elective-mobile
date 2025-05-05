// lib/screens/add_medicine_screen.dart
import 'package:flutter/material.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
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
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Input Quantity'),
                    onChanged: (v) => _medicines[index]['quantity'] = v,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if ((_medicines[index]['quantity'] ?? '').isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a quantity.'), duration: Duration(seconds: 2)),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${_medicines[index]['quantity']} of ${_medicines[index]['name']}'),
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
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu functionality not implemented yet.'), duration: Duration(seconds: 2)),
          );
        }),
        title: const Text('Add Medicine'),
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFF0F4C3)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
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
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildLabelChip('Label 1', true),
                  _buildLabelChip('Label 2', false),
                  _buildLabelChip('Label 3', false),
                  _buildLabelChip('Label 4', false),
                  _buildLabelChip('Label 5', false),
                ],
              ),
              const SizedBox(height: 20),
              ..._medicines.map((m) => _buildMedicineCard(_medicines.indexOf(m))),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _addMedicine, child: const Text('Add Medicine')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      backgroundColor: Colors.grey[300],
      selectedColor: Colors.blue[200],
    );
  }
}
