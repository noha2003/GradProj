import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isDisabled = false, 
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isDisabled; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 356,
      height: 102,
      child: ElevatedButton.icon(
        onPressed: isDisabled
            ? null
            : onTap, 
        icon: Icon(
          icon,
          color: isDisabled
              ? Colors.grey
              : const Color(0xFF7A0000),
          size: 80,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: isDisabled
                ? Colors.grey
                : const Color(0xFF7A0000),
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey[300] 
              : const Color.fromRGBO(217, 217, 217, 1),
          foregroundColor: isDisabled ? Colors.grey : const Color(0xFF7A0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: isDisabled
                  ? Colors.grey
                  : const Color(0xFF7A0000), 
            ),
          ),
          elevation: isDisabled ? 0 : 4, 
          shadowColor: Colors.black26,
        ),
      ),
    );
  }
}
