import 'package:flutter/material.dart';
import 'add_medicine_screen.dart';

const primaryBlue = Color(0xFF4FC3F7);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isChecked = false;

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms and Conditions'),
        content: SingleChildScrollView(
          child: Text(
                'By using this app, you agree to take your medications responsibly. '
                'The app serves only as a reminder and does not replace professional medical advice. '
                'Ensure your medicine schedule is accurate and updated. '
                'The developers are not liable for any missed doses or adverse health outcomes. '
                'Your data is kept locally and used only for app functionality. '
                'By continuing, you acknowledge and accept these terms.',
            style: TextStyle(fontSize: 14.5, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (val) {
            setState(() {
              _isChecked = val ?? false;
            });
          },
        ),
        GestureDetector(
          onTap: _showTermsDialog,
          child: RichText(
            text: TextSpan(
              text: 'I agree to the ',
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.favorite, size: 150.0, color: primaryBlue),
                      Icon(Icons.favorite, size: 120.0, color: Colors.white),
                      Icon(Icons.notifications_none, size: 60.0, color: primaryBlue),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Take your\nmedicine\nresponsibly\nwith\nMedisync!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTermsCheckbox(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isChecked
                        ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
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

    paint.color = const Color(0xFFF4F8FB);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    Path topRight = Path();
    topRight.moveTo(size.width * 0.4, 0);
    topRight.quadraticBezierTo(size.width * 0.95, size.height * 0.1, size.width * 0.85, size.height * 0.3);
    topRight.quadraticBezierTo(size.width * 0.8, size.height * 0.4, size.width, size.height * 0.4);
    topRight.lineTo(size.width, 0);
    topRight.close();

    paint.color = const Color(0xFF81D4FA);
    canvas.drawPath(topRight, paint);

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
