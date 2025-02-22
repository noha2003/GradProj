import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradproj/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    });
    super
        .initState(); //used to initialize variables, start animations, fetch data, or set up listeners.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: Center(
        child:
            Hero(tag: "logo", child: Image.asset('assets/images/sawtkm3.jpeg')),
      ),
    );
  }
}