import 'package:flutter/material.dart';
import 'package:gradproj/main_screen.dart';
import 'package:gradproj/signup/s1.dart';
import 'forgetpass/f1.dart';
//import 'signup/s1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 20),
              // Align Moves the text to the right of its parent.
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

           
            const SizedBox(height: 20), 


            // Logo Image 
            Image.asset(
              'assets/images/sawtkm3.jpeg',
              width: 350, //size of the photo
            ),

            const SizedBox(height: 5), 

            //login container
            Container(
              padding: const EdgeInsets.all(20),
              height: 380, //container height
              decoration: const BoxDecoration(
                color: Color(0xFF7D1616),
                borderRadius:
                BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                      hintText: "Email", icon: Icons.person, isPassword: false),
                  const SizedBox(height: 25), // Increased space between fields
                  _buildTextField(
                      hintText: "Password", icon: Icons.lock, isPassword: true),
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
                      child: const Text("Forgot Password?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                            Navigator.push(
                            context,
                           MaterialPageRoute(
                          builder: (context) =>
                           const MainScreen()),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize:
                          const Size(320, 50), // Set width to match text field
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Login",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",
                          style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          // Navigate to Sign Up screen
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) =>
                            const RegistrationScreen()),
                          );
                        },
                        child: const Text("Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
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

  Widget _buildTextField(
      {required String hintText,
      required IconData icon,
      required bool isPassword}) 
      {
    return SizedBox(
      width: 320, //  width of the text field
      child: TextField(
        obscureText: isPassword ? !_isPasswordVisible : false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          suffixIcon: isPassword
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