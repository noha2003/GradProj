import 'package:flutter/material.dart';
import 'package:gradproj/home.dart';
import 'package:gradproj/main_screen.dart';

class SuccessWithdraw extends StatelessWidget {
  const SuccessWithdraw({super.key});
  @override
  Widget build(BuildContext context) {
    return Home(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 200,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 30),
           const  Text(
              "تم انسحابك من  الانتخابات لهذه الدورة بنجاح. ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(122, 0, 0, 1),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(122, 0, 0, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "الرجوع إلى الصفحة الرئيسية",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}