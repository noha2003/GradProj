import 'package:flutter/material.dart';
import '../header.dart'; // Import your existing header file
import 'f2.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9), // Background color
      body: SingleChildScrollView(
        // Add scroll view to prevent overflow
        child: Column(
          children: [
            const Header(), // Use the existing header

            const SizedBox(height: 80), // Space between header and content

            const Text(
              "Forgot Password",
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
              "Please enter your Email to receive\n a verification code",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // EMAIL Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000)), // Dark red border
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000),
                        width: 2), // Dark red on focus
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF7A0000)), // Dark red default
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),

            // Confirm & Back Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle confirmation logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OTPVerificationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A0000), // Dark red
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to previous screen
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
                  child: const Text("Back",
                      style: TextStyle(color: Color(0xFF7A0000), fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}