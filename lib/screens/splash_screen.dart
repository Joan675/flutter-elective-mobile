// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'add_medicine_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
        CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: WavyBackgroundPainter(),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.favorite, size: 150.0, color: Color(0xFF4FC3F7)), // Outer blue heart
                    Icon(Icons.favorite, size: 120.0, color: Colors.white),       // Inner white heart
                    Positioned(
                      child: Icon(Icons.notifications_none, size: 60.0, color: Color(0xFF4FC3F7)),
                    ),
                  ],
                ),
                const Text("Take your\nmedicine\nresponsibly\nwith\nMedisync!",
                textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4FC3F7),
                    )
                  ),
                  const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
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
        ],
      ),
    );
  }
}

class WavyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Light background
    paint.color = const Color(0xFFF4F8FB);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Top right wave
    // 2. Top-right abstract shape
    Path topRight = Path();
    topRight.moveTo(size.width * 0.4, 0);
    topRight.quadraticBezierTo(size.width * 0.95, size.height * 0.1, size.width * 0.85, size.height * 0.3);
    topRight.quadraticBezierTo(size.width * 0.8, size.height * 0.4, size.width, size.height * 0.4);
    topRight.lineTo(size.width, 0);
    topRight.close();

    paint.color = const Color(0xFF81D4FA); // Medium blue
    canvas.drawPath(topRight, paint);

    // Bottom left arc
    Path bottomLeft = Path();
    bottomLeft.moveTo(0, size.height);
    bottomLeft.quadraticBezierTo(
        size.width * 0.1, size.height * 0.85, size.width * 0.3, size.height * 0.9);
    bottomLeft.quadraticBezierTo(
        size.width * 0.5, size.height * 0.95, size.width * 0.5, size.height);
    bottomLeft.lineTo(0, size.height);
    bottomLeft.close();

    paint.color = const Color(0xFF81D4FA); // Medium blue
    canvas.drawPath(bottomLeft, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
