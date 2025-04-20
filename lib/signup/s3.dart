import 'package:flutter/material.dart';

import '../header.dart';
import '../login_screen.dart';

/*void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OTPVerificationScreen(),
  ));
}*/

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  bool isLoading = false;

  void resendOTP() {
    setState(() {
      isLoading = true;
    });

    // Simulate the OTP resend operation with a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      // Show a Snackbar or AlertDialog to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رمز التحقق مرة أخرى!'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: 40),
            const Icon(
              Icons.email,
              size: 180,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'تم ارسال رابط تحقق الى بريدك الألكتروني, الرجاء التحقق من البريد لأكمال عملية تسجيل الدخول',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: isLoading ? null : resendOTP,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  : const Text(
                      'إعادة إرسال رمز التحقق',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A0000),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'تأكيد',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
