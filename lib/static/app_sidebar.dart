import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import '../screens/add_medicine_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/map_screen.dart';
import '../screens/chat_screen.dart';

// Centralized route map
final Map<String, WidgetBuilder> sidebarRoutes = {
  'home': (context) => const HomePage(),
  'add': (context) => const AddMedicineScreen(),
  'profile': (context) => const ProfileScreen(),
  'navigation': (context) => const MapScreen(),
  'chat': (context) => const ChatScreen(),
};

// Centralized navigation handler
void handleSidebarNavigation(BuildContext context, String key) {
  Navigator.pop(context); // Close the drawer
  final builder = sidebarRoutes[key];
  if (builder != null) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: builder));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Page for "$key" not found')),
    );
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.favorite, size: 60, color: Colors.lightBlue),
          const Divider(thickness: 1),
          _buildMenuItem(context, Icons.home, "Home Page", "home"),
          _buildMenuItem(context, Icons.add_circle_outline, "Add Prescription", "add"),
          _buildMenuItem(context, Icons.person_outline, "My Profile", "profile"),
          _buildMenuItem(context, Icons.place_outlined, "Navigation", "navigation"),
          _buildMenuItem(context, Icons.chat_bubble_outline, "Talk to Synciee", "chat"),
          const Spacer(),
          const Divider(thickness: 1),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, String key) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightBlue),
      title: Text(label, style: const TextStyle(color: Colors.lightBlue)),
      onTap: () => handleSidebarNavigation(context, key),
    );
  }
}
