import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/add_medicine_screen.dart'; // ← your main screen
import 'models/medicine.dart';             // ← your Medicine model
import 'screens/splash_screen.dart';
import 'data/seed_medicines.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  
  WidgetsFlutterBinding.ensureInitialized();

  // Set up Hive storage path
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // Register adapter
  Hive.registerAdapter(MedicineAdapter());

  // Open the box
  var box = await Hive.openBox<Medicine>('medicines');

  // TEMP: Clear existing data
  await box.clear();

  // Seed sample medicines only once
  if (box.isEmpty) {
    box.addAll(seedMedicines);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Medicine Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // your screen
    );
  }
}
