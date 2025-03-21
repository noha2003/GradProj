import 'package:flutter/material.dart';

class Header_without extends StatelessWidget {
  const Header_without({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      decoration: const BoxDecoration(
        color: Color(0xFF7A0000),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
