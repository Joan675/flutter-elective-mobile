import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../static/wavy_background.dart';
import '../static/app_sidebar.dart';
import 'frequency_screen.dart';
import '../models/medicine.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final List<String> _labels = const [
    'All', 'Liquid', 'Capsule', 'Tablet', 'Drops', 'Inhalers', 'Injections', 'Patches'
  ];

  int _selectedIndex = 0; // Capsule
  final TextEditingController _searchController = TextEditingController();
  List<Medicine> _allMedicines = [];
  List<Medicine> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    final box = Hive.box<Medicine>('medicines');
    _allMedicines = box.values.toList();
    _applyFilter();
  }

  void _applyFilter() {
    String selectedType = _labels[_selectedIndex];
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredMedicines = _allMedicines.where((m) {
        bool matchesType = selectedType == 'All'
            ? true
            : m.medtype.toLowerCase().contains(selectedType.toLowerCase());

        bool matchesSearch = m.name.toLowerCase().contains(query) ||
                            m.brand.toLowerCase().contains(query) ||
                            m.uses.toLowerCase().contains(query);

        return matchesType && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppSidebar(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Add Medicine', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const WavyBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 18),
                  _buildLabelChips(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _filteredMedicines.isEmpty
                        ? const Center(child: Text("No medicines found."))
                        : ListView.builder(
                            itemCount: _filteredMedicines.length,
                            itemBuilder: (_, i) => _buildMedicineCard(_filteredMedicines[i]),
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

  Widget _buildSearchBar() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _applyFilter(),
        decoration: InputDecoration(
          hintText: 'Search Medicine',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilter();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildLabelChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (ctx, i) => ChoiceChip(
          label: Text(_labels[i]),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          selected: _selectedIndex == i,
          selectedColor: Colors.lightBlue.shade100,
          backgroundColor: Colors.grey[200],
          onSelected: (_) {
            setState(() {
              _selectedIndex = i;
              _applyFilter();
            });
          },
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: value.isNotEmpty ? value : "N/A",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard(Medicine m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Name
            Text(
              m.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 12),

            // Medicine details
            _buildInfoRow("Brand", m.brand),
            _buildInfoRow("Type", m.medtype),
            _buildInfoRow("Uses", m.uses),
            _buildInfoRow("Side Effects", m.sideEffects),
            _buildInfoRow("Ingredients", m.ingredients),
            _buildInfoRow("Directions", m.directions),
            _buildInfoRow("Warnings", m.warnings),

            const SizedBox(height: 18),

            // Add Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FrequencyScreen(selectedMedicine: m),),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[300],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}