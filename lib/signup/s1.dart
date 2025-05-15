import 'dart:async';

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
  bool _isDataLoaded = false;
  String? _documentId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_onIdChanged);
  }

  void _onIdChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchUserData();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _idController.removeListener(_onIdChanged);
    _idController.dispose();
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _fetchUserData() async {
    if (_idController.text.isEmpty) {
      return false;
    }

    try {
      int nationalId = int.parse(_idController.text);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('nationalId', isEqualTo: nationalId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        _documentId = querySnapshot.docs.first.id;
        print('Document ID found: $_documentId');
        setState(() {
          _isDataLoaded = true;
          _fullNameController.text = userData['name'] ?? '';
          _dobController.text = userData['birthDate'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
        });
        return true;
      } else {
        print('No document found for nationalId: $nationalId');
        setState(() {
          _isDataLoaded = false;
          _fullNameController.clear();
          _dobController.clear();
          _phoneController.clear();
          _documentId = null;
        });
        return false;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isDataLoaded = false;
        _fullNameController.clear();
        _dobController.clear();
        _phoneController.clear();
        _documentId = null;
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'خطأ',
        desc: 'يرجى إدخال رقم وطني صحيح (أرقام فقط)',
        btnOkOnPress: () {},
      ).show();
      return false;
    }
  }

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
    try {
      DateTime birthDate = DateFormat('dd/MM/yyyy').parse(dob);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;

      if (currentDate.month < birthDate.month ||
          (currentDate.month == birthDate.month &&
              currentDate.day < birthDate.day)) {
        age--;
      }
      return age >= 18;
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'خطأ',
        desc: 'تاريخ الميلاد غير صالح: $dob',
        btnOkOnPress: () {},
      ).show();
      return false;
    }
  }

  Future<void> _storeUserData() async {
    if (_documentId == null) {
      print('Document ID is null. Cannot update document.');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'خطأ',
        desc: 'لا يمكن العثور على المستند المطلوب',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    try {
      // إنشاء مستخدم في Firebase Authentication
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // الحصول على uid الجديد
      String newUid = credential.user!.uid;
      print('New UID from Authentication: $newUid');

      // تحديث مستند Firestore بالـ uid الجديد
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_documentId)
          .update({
        'uid': newUid,
        'email': _emailController.text,
        'password': _passwordController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'isVoting': false,
        'status': 'غير مرشح',
      });

      await _sendOTP();
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
      print('Error storing user data: $e');
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length <= 8) {
      return 'كلمة المرور يجب أن تكون أكثر من 8 خانات';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'كلمة المرور يجب أن تحتوي على رمز واحد على الأقل (مثل !@#%^&*)';
    }
    return null;
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
                  maxLength: 80, isReadOnly: true),
              _buildDatePickerField(
                  "تاريخ الميلاد", Icons.calendar_today, _dobController,
                  isReadOnly: true),
              _buildInputField("رقم الهاتف", Icons.phone, _phoneController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  isReadOnly: true),
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
                      bool idExists = await _fetchUserData();
                      if (!idExists || !_isDataLoaded) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: 'الرقم الوطني غير موجود في النظام',
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

                      if (_isDataLoaded &&
                          !_isEligibleForRegistration(_dobController.text)) {
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
      {int maxLength = 80,
      TextInputType keyboardType = TextInputType.text,
      bool isReadOnly = false}) {
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
            readOnly: isReadOnly,
            validator: (value) => isReadOnly
                ? null
                : value!.isEmpty
                    ? 'يرجى ملء هذا الحقل'
                    : null,
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
            validator: (value) => isPassword
                ? _validatePassword(value)
                : value != _passwordController.text
                    ? 'كلمة المرور غير متطابقة'
                    : null,
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
      String label, IconData icon, TextEditingController controller,
      {bool isReadOnly = false}) {
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
            validator: (value) => isReadOnly && value!.isEmpty
                ? 'يرجى اختيار تاريخ الميلاد'
                : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
