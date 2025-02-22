import 'package:flutter/material.dart';
import 'package:gradproj/header.dart';

class Home extends StatelessWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
      body: Column(
        children: [
          const Header(), 
          Expanded (child: SizedBox(
            width: double.infinity,
            child: child), ),
        ],
      ),
    );
  }
}