import 'package:flutter/material.dart';
import '../header.dart';
import 's3.dart';

class RegistrationStepTwo extends StatefulWidget {
  const RegistrationStepTwo({super.key});

  @override
  State<RegistrationStepTwo> createState() => _RegistrationStepTwoState();
}

class _RegistrationStepTwoState extends State<RegistrationStepTwo> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _familyBookDateController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(), // Header

            const SizedBox(height: 40),

            _buildInputField("رقم الهاتف", Icons.phone, _phoneController),
            _buildInputField(
                "البريد الإلكتروني", Icons.email, _emailController),
            _buildPasswordField("كلمة المرور", _passwordController, true),
            _buildPasswordField(
                "تأكيد كلمة المرور", _confirmPasswordController, false),
            _buildInputField("ادخل تاريخ اصدار دفتر العائلة",
                Icons.calendar_today, _familyBookDateController),

            const SizedBox(height: 50),

            // ✅ Arabic button order: رجوع (Left), التالي (Right)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // This will navigate back to the previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    side: const BorderSide(color: Color(0xFF7A0000)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("رجوع",
                      style: TextStyle(color: Color(0xFF7A0000), fontSize: 16)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    //Navigate to the next screen or perform an action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OTPVerificationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A0000),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("التالي",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 📌 Function to create input fields
  Widget _buildInputField(
      String hint, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 16),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: Color(0xFF7A0000)), // ✅ Red border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: Color(0xFF7A0000)), // ✅ Red border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
                color: Color(0xFF7A0000), width: 2), // ✅ Thicker when focused
          ),
        ),
      ),
    );
  }

  // 📌 Function to create password fields with visibility toggle
  Widget _buildPasswordField(
      String hint, TextEditingController controller, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : _obscureConfirmPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 16),
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              isPassword
                  ? (_obscurePassword ? Icons.visibility_off : Icons.visibility)
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: Color(0xFF7A0000)), // ✅ Red border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: Color(0xFF7A0000)), // ✅ Red border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
                color: Color(0xFF7A0000), width: 2), // ✅ Thicker when focused
          ),
        ),
      ),
    );
  }
}