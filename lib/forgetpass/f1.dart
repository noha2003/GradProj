import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../header.dart'; // استيراد ملف الهيدر
import '../login_screen.dart'; // استيراد ملف شاشة تسجيل الدخول

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة لإعادة تعيين كلمة المرور
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      // إذا كان حقل البريد الإلكتروني فارغًا، أظهر تحذيرًا
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان بريدك الإلكتروني')),
      );
      return; // الخروج من الدالة مبكرًا
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      // إظهار رسالة النجاح
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال بريد إعادة تعيين كلمة المرور!')),
      );
      // الانتقال إلى شاشة تسجيل الدخول بعد النجاح
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // التعامل مع أخطاء Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9), // لون الخلفية
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(), // استخدام ويدجت الهيدر هنا

            const SizedBox(height: 100), // مسافة بين الهيدر والمحتوى

            const Text(
              "نسيت كلمة المرور",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 27),

            const Icon(
              Icons.lock,
              size: 120,
              color: Colors.grey,
            ),

            const SizedBox(height: 20),

            const Text(
              "يرجى إدخال بريدك الإلكتروني لإعادة تعيين كلمة المرور الخاصة بك",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // إدخال البريد الإلكتروني
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000)), // حدود حمراء داكنة
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000),
                        width: 2), // أحمر داكن عند التركيز
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000)), // أحمر داكن افتراضي
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // زر التأكيد - في المنتصف
            Center(
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A0000), // أحمر داكن
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "تأكيد",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
