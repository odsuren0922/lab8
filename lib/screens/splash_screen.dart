import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  // Navigate after a delay
  Future<void> _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    Color splashBackgroundColor = const Color(0xFF57A29F);
    return Scaffold(
      backgroundColor: splashBackgroundColor,
      body: const Center(
        child: Text(
          'Сайн уу?',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
    );
  }
}
