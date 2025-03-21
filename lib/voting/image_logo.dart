import 'package:flutter/material.dart';

class ImageLogo extends StatelessWidget {
  const ImageLogo({super.key, required this.imagePath});
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF7A0000), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(217, 217, 217, 1).withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(image: AssetImage(imagePath), scale: 2.5),
        ),
      ),
    );
  }
}





/*CircleAvatar(
      radius: 40,
      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
      child: Image.asset(
        'assets/images/tajdeed.png', // استبدلها بصورة الشعار
        height: 50,
        fit: BoxFit.contain,
      ),
    );*/ 