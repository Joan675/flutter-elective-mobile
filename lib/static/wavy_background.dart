import 'package:flutter/material.dart';

class WavyBackground extends StatelessWidget {
  const WavyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      painter: WavyBackgroundPainter(),
    );
  }
}

class WavyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Background
    paint.color = const Color(0xFFF4F8FB);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Top-right wave
    Path topRight = Path();
    topRight.moveTo(size.width * 0.4, 0);
    topRight.quadraticBezierTo(size.width * 0.95, size.height * 0.1, size.width * 0.85, size.height * 0.3);
    topRight.quadraticBezierTo(size.width * 0.8, size.height * 0.4, size.width, size.height * 0.4);
    topRight.lineTo(size.width, 0);
    topRight.close();
    paint.color = const Color(0xFF81D4FA);
    canvas.drawPath(topRight, paint);

    // Bottom-left arc
    Path bottomLeft = Path();
    bottomLeft.moveTo(0, size.height);
    bottomLeft.quadraticBezierTo(
        size.width * 0.1, size.height * 0.85, size.width * 0.3, size.height * 0.9);
    bottomLeft.quadraticBezierTo(
        size.width * 0.5, size.height * 0.95, size.width * 0.5, size.height);
    bottomLeft.lineTo(0, size.height);
    bottomLeft.close();
    paint.color = const Color(0xFF81D4FA);
    canvas.drawPath(bottomLeft, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
