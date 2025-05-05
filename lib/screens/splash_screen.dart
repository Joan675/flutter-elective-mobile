// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'next_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFF0F4C3)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Stack(
                  children: [
                    Icon(Icons.favorite, size: 100.0, color: Color(0xFF4FC3F7)),
                    Positioned(
                      top: 20, left: 20,
                      child: Icon(Icons.notifications, size: 30.0, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text("Take your",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, color: Color(0xFF00897B)),
                  textAlign: TextAlign.center,
                ),
                const Text("Medicine",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, color: Color(0xFF00897B)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text("Responsibly now with",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, color: Color(0xFF00897B)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text("MediaSync!",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700, color: Color(0xFF00897B)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NextScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FC3F7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 5,
                  ),
                  child: const Text("Start Being Responsible", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
