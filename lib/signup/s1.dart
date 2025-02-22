import 'package:flutter/material.dart';
import '../header.dart';
import 's2.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(), // ✅ Importing and using the header

            const SizedBox(height: 40),

            _buildInputField("الرقم الوطني", Icons.person, _idController),
            _buildInputField(
                "الاسم الكامل", Icons.account_circle, _fullNameController),
            _buildInputField(
                "تاريخ الميلاد", Icons.calendar_today, _dobController),
            _buildInputField("العنوان", Icons.location_on, _addressController),
            _buildInputField("رمز البريد", Icons.email, _postalCodeController),

            const SizedBox(height: 50),

            // ✅ Fix: Arabic button order (رجوع on the left, التالي on the right)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                    "رجوع", const Color(0xFFD9D9D9), const Color(0xFF7A0000),
                    () {
                  Navigator.pop(context);
                }, border: true),
                const SizedBox(width: 20),
                _buildButton("التالي", const Color(0xFF7A0000), Colors.white,
                    () {
                  // Navigate to next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationStepTwo()),
                  );
                }),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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

  // 📌 Function to create buttons
  Widget _buildButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed,
      {bool border = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        side: border
            ? const BorderSide(color: Color(0xFF7A0000))
            : BorderSide.none, // ✅ Border for "رجوع" button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
    );
  }
}
