// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/add_medicine_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/date_screen.dart';
import 'screens/map_screen.dart';
import 'screens/frequency_screen.dart';
import 'screens/home_page.dart';
import 'screens/alarm_screen.dart';
import 'screens/logs_screen.dart';
import 'screens/meds_screen.dart';
import 'screens/next_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediSync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
