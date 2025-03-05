import 'package:flutter/material.dart';

import '../header.dart';
import 'election2.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ElectionCodeScreen(),
  ));
}

class ElectionCodeScreen extends StatelessWidget {
  const ElectionCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9), // Background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'للتقدم للانتخابات، يجب أن تكون ضمن قائمة انتخابية، وتشترط إدخال الرمز الخاص بالقائمة لإتمام الطلب',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A0000),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Icon(
              Icons.fact_check, // Similar icon
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'ادخل رمز القائمة الانتخابية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A0000),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000)), // Red border
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000)), // Red border
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000)), // Red border
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    side: const BorderSide(
                        color: Color(0xFF7A0000)), // Red border
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'رجوع',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7A0000), // Red text
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A0000), // Red background
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationForm()),
                    );
                  },
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
