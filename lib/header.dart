import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xFF7A0000),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo.jpeg',
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
