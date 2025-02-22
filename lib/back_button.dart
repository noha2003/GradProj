import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
        foregroundColor: const Color(0xFF7A0000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF7A0000)),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        minimumSize: const Size(144, 44),
      ),
      child: const Text("رجوع",
          style: TextStyle(color: Color(0xFF7A0000), fontSize: 20, 
          fontWeight: FontWeight.normal)),
    );
  }
}
