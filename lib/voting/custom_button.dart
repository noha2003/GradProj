import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isDisabled = false, // إضافة خاصية isDisabled مع قيمة افتراضية false
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isDisabled; // المعلمة الجديدة

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 356,
      height: 102,
      child: ElevatedButton.icon(
        onPressed: isDisabled
            ? null
            : onTap, // إذا كان isDisabled true، يتم تعطيل الضغط
        icon: Icon(
          icon,
          color: isDisabled
              ? Colors.grey
              : const Color(0xFF7A0000), // تغيير اللون عند التعطيل
          size: 80,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: isDisabled
                ? Colors.grey
                : const Color(0xFF7A0000), // تغيير لون النص
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey[300] // لون خلفية باهت عند التعطيل
              : const Color.fromRGBO(217, 217, 217, 1),
          foregroundColor: isDisabled ? Colors.grey : const Color(0xFF7A0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              color: isDisabled
                  ? Colors.grey
                  : const Color(0xFF7A0000), // لون الحدود
            ),
          ),
          elevation: isDisabled ? 0 : 4, // إزالة الظل عند التعطيل
          shadowColor: Colors.black26,
        ),
      ),
    );
  }
}
