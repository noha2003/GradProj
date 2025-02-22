import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7A0000),
        foregroundColor: const Color.fromRGBO(217, 217, 217, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF7A0000)),
        ),
        elevation: 4,
        minimumSize: const Size(144, 44),
      ),
      child: const Text("تأكيد",
          style: TextStyle(color: Colors.white, fontSize: 20 ,
          fontWeight: FontWeight.normal)),
    );
  }
}
