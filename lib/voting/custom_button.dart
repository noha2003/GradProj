import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.icon, required this.text, required this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 356,
      height: 102,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF7A0000), size: 80),
        label: Text(
          text,
          style: const TextStyle(fontSize: 20 , color:Color(0xFF7A0000), 
          fontWeight: FontWeight.bold),
        
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          foregroundColor: const Color(0xFF7A0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Color(0xFF7A0000)),
          ),
          elevation: 4,
          shadowColor: Colors.black26,
        ),
      ),
    );
  }
}
