import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.icon, required this.text, required this.onTap});
 final IconData icon;
  final String text;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return   SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF7A0000)),
        label: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF7A0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color:Color(0xFF7A0000)),
          ),
          elevation: 4,
          shadowColor: Colors.black26,
        ),
      ),
    );
   
  }
}