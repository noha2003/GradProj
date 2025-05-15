import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../header.dart';
import 's3.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _sendOTP() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'OTP Sent',
        desc: 'Please check your email for the verification code.',
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Failed to send OTP: $e',
        btnOkOnPress: () {},
      ).show();
    }
  }

  bool _isEligibleForRegistration(String dob) {
    DateTime birthDate = DateFormat('yyyy-MM-dd').parse(dob);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age >= 18;
  }

  Future<void> _storeUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_idController.text)
          .set({
        'id': _idController.text,
        'full_name': _fullNameController.text,
        'dob': _dobController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'uid': user?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'تم التسجيل بنجاح',
        desc: 'تم إنشاء حسابك بنجاح. تحقق من بريدك الإلكتروني لتفعيل الحساب',
        btnOkOnPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const OTPVerificationScreen()),
          );
        },
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Failed to store user data: $e',
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future<bool> _checkExistingNationalId(String nationalId) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(nationalId)
        .get();
    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: 40),
              _buildInputField("الرقم الوطني", Icons.person, _idController,
                  maxLength: 10, keyboardType: TextInputType.number),
              _buildInputField(
                  "الاسم الكامل", Icons.account_circle, _fullNameController,
                  maxLength: 80),
              _buildDatePickerField(
                  "تاريخ الميلاد", Icons.calendar_today, _dobController),
              _buildInputField("رقم الهاتف", Icons.phone, _phoneController,
                  maxLength: 10, keyboardType: TextInputType.phone),
              _buildInputField(
                  "البريد الإلكتروني", Icons.email, _emailController,
                  maxLength: 80),
              _buildPasswordField("كلمة المرور", _passwordController, true,
                  maxLength: 80),
              _buildPasswordField(
                  "تأكيد كلمة المرور", _confirmPasswordController, false,
                  maxLength: 80),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("التالي", const Color(0xFF7A0000), Colors.white,
                      () async {
                    if (_formKey.currentState!.validate()) {
                      bool idExists =
                          await _checkExistingNationalId(_idController.text);
                      if (idExists) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: 'الرقم الوطني مستخدم بالفعل',
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: 'كلمات المرور غير متطابقة',
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      if (!_isEligibleForRegistration(_dobController.text)) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'عذراً',
                          desc: 'يجب أن يكون عمرك 18 سنة أو أكبر للتسجيل.',
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        await _sendOTP();
                        await _storeUserData();
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = e.code == 'weak-password'
                            ? 'كلمة المرور ضعيفة'
                            : e.code == 'email-already-in-use'
                                ? 'البريد الإلكتروني مستخدم بالفعل'
                                : 'البريد الألكتروني خاطئ';
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: errorMessage,
                          btnOkOnPress: () {},
                        ).show();
                      }
                    }
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, IconData icon, TextEditingController controller,
      {int maxLength = 80, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A0000),
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: (value) => value!.isEmpty ? 'يرجى ملء هذا الحقل' : null,
            maxLength: maxLength,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: Icon(icon, color: Colors.grey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isPassword,
      {int maxLength = 80}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A0000),
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText:
                isPassword ? _obscurePassword : _obscureConfirmPassword,
            validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال كلمة المرور' : null,
            maxLength: maxLength,
            decoration: InputDecoration(
              counterText: '',
              prefixIcon: const Icon(Icons.lock, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  isPassword
                      ? (_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility)
                      : (_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isPassword) {
                      _obscurePassword = !_obscurePassword;
                    } else {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }
                  });
                },
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      String text, Color color, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDatePickerField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A0000),
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: true,
            validator: (value) =>
                value!.isEmpty ? 'يرجى اختيار تاريخ الميلاد' : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate!);
              setState(() {
                controller.text = formattedDate;
              });
                        },
          ),
        ],
      ),
    );
  }
}
