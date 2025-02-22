import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNav(
      {super.key, required this.onTabSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
      height: 65,
      color: const Color(0xFF7A0000),
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.menu_outlined, size: 40, color: Colors.white),
        Icon(Icons.person, size: 40, color: Colors.white),
        Icon(Icons.notifications, size: 40, color: Colors.white),
        Icon(Icons.home, size: 40, color: Colors.white),
      ],
      onTap: (index) {
        onTabSelected(index);
      },
    );
  }
}