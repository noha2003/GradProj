// import 'package:flutter/material.dart';
// import '../header.dart'; // Import the existing header file
// import '../login_screen.dart';

// class NewPasswordScreen extends StatefulWidget {
//   const NewPasswordScreen({super.key});

//   @override
//   State<NewPasswordScreen> createState() => _NewPasswordScreenState();
// }

// class _NewPasswordScreenState extends State<NewPasswordScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFD9D9D9), // Background color
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const Header(), // Existing header

//             const SizedBox(height: 50), // Space after header

//             const Text(
//               "Create New Password",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 20),

//             const Icon(
//               Icons.lock,
//               size: 120,
//               color: Colors.grey,
//             ),

//             const SizedBox(height: 20),

//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: Text(
//                 "Your new password must be different from the previous one used.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // New Password Input
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: TextField(
//                 controller: _passwordController,
//                 obscureText: true, // Hide password input
//                 decoration: InputDecoration(
//                   hintText: "New Password",
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                         color: Color(0xFF7A0000), width: 2), // Dark red border
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                         color: Color(0xFF7A0000),
//                         width: 1.5), // Dark red border
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // Confirm Password Input
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: TextField(
//                 controller: _confirmPasswordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Confirm Password",
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                         color: Color(0xFF7A0000), width: 2), // Dark red border
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(
//                         color: Color(0xFF7A0000),
//                         width: 1.5), // Dark red border
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 80),

//             // Save & Back Buttons (Same as Forgot Password screen)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle saving logic
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginScreen()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF7A0000), // Dark red
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 40, vertical: 10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text("Save",
//                       style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ),
//                 const SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Go back to the previous screen
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFD9D9D9),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 40, vertical: 10),
//                     side: const BorderSide(color: Color(0xFF7A0000)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text("Back",
//                       style: TextStyle(color: Color(0xFF7A0000), fontSize: 16)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
