import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clipyronment/ip_config_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IPConfigPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'Images/Logo.png',
              width: 200, // Adjust size as needed
              height: 200,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Color(0xFF00FF41), // Hacker green to match your theme
            ),
          ],
        ),
      ),
    );
  }
}
