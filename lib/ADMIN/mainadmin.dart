import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/ADMIN/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إدارة القوائم',
      theme: ThemeData(
        primaryColor: const Color(0xFF7A0000),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF7A0000),
          secondary: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        fontFamily: 'Cairo',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginScreen(),
    );
  }
}

