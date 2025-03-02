import 'package:flutter/material.dart';
import 'package:gradproj/back_to_home_button.dart';
import 'package:gradproj/home2.dart';

class SubmitVoting extends StatelessWidget {
  const SubmitVoting({super.key});

  @override
  Widget build(BuildContext context) {
    return Home_without(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 123),
        Image.asset('assets/images/votesubmit.png'),
        const SizedBox(height: 20),
        const Text("تم الإدلاء بصوتك بنجاح.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Color(0xFF7A0000),
            )),
        const SizedBox(height: 10),
        const Text("شكراً لمشاركتك في العملية الانتخابية",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Color(0xFF7A0000),
            )),
        const Spacer(flex: 1),
        const BackToHomeButton(),
        const SizedBox(height: 40),
      ],
    ));
  }
}
