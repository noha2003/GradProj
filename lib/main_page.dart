import 'package:flutter/material.dart';
import 'package:gradproj/custombutton.dart';
import 'package:gradproj/home.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Home(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              icon: Icons.list_alt,
              text: "القوائم الانتخابية",
              onTap: () => Navigator.pushNamed(context, '/electionLists'),
            ),
            const SizedBox(height: 20),
            CustomButton(
              icon: Icons.how_to_vote,
              text: "ابدأ التصويت",
              onTap: () => Navigator.pushNamed(context, '/startVoting'),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "رجوع",
                style: TextStyle(fontSize: 18, color: Colors.red[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
