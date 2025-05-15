import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/main_screen.dart';
import 'package:gradproj/signup/s1.dart';

import 'forgetpass/f1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _languageButton("AR", true, Colors.black),
                    const SizedBox(width: 10),
                    _languageButton("EN", false, const Color(0xFF7D1616)),
                  ],
                ),
              ),
            ),
            Image.asset(
              'assets/images/sawtkm3.jpeg',
              width: 380,
            ),
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.only(
                  left: 20, bottom: 0, right: 20, top: 80),
              height: 430,
              decoration: const BoxDecoration(
                color: Color(0xFF7D1616),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                      hintText: "البريد الإلكتروني",
                      icon: Icons.person,
                      isPassword: false,
                      controller: _emailController),
                  const SizedBox(height: 25),
                  _buildTextField(
                      hintText: "كلمة المرور",
                      icon: Icons.lock,
                      isPassword: true,
                      controller: _passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text("نسيت كلمة المرور؟",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: 'يرجى إدخال البريد الإلكتروني وكلمة المرور.',
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      } on FirebaseAuthException catch (e) {
                        String errorMessage =
                            'حدث خطأ. يرجى المحاولة مرة أخرى.';

                        if (e.code == 'user-not-found') {
                          errorMessage =
                              'لم يتم العثور على مستخدم لهذا البريد الإلكتروني.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'كلمة المرور المقدمة لهذا المستخدم خاطئة.';
                        }

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'فشل تسجيل الدخول',
                          desc: errorMessage,
                          btnOkOnPress: () {},
                        ).show();
                      } catch (e) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
                          btnOkOnPress: () {},
                        ).show();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0B0B0),
                      minimumSize: const Size(320, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("تسجيل الدخول",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen()),
                          );
                        },
                        child: const Text("انشاء حساب ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      const Text("ليس لديك حساب؟",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        textDirection: TextDirection.rtl, // اتجاه النص من اليمين إلى اليسار
        textAlign: TextAlign.right, // محاذاة النص إلى اليمين
        decoration: InputDecoration(
          suffixIcon: Icon(icon, color: Colors.grey), // الأيقونة على اليسار
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          prefixIcon: isPassword // أيقونة إظهار/إخفاء كلمة المرور على اليمين
              ? IconButton(
                  icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _languageButton(String text, bool selected, Color textColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD9D9D9),
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: const BorderSide(color: Colors.white),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
