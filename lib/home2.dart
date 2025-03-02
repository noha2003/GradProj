import 'package:flutter/material.dart';
import 'package:gradproj/header2.dart';

class Home_without extends StatelessWidget {
  final Widget child;
  const Home_without({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
      body: Column(
        children: [
          const Header_without(),
          Expanded(
            child: SizedBox(width: double.infinity, child: child),
          ),
        ],
      ),
    );
  }
}
