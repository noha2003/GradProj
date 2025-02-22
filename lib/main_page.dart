import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/voting/custom_button.dart';
import 'package:gradproj/election_district.dart';
import 'package:gradproj/home.dart';
import 'package:gradproj/voting/voting_lists.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Home(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 124),
              child: CustomButton(
                  icon: Icons.list_alt,
                  text: "القوائم الانتخابية",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ElectionDistrictsScreen(forView: true);
                    }));
                  }),
            ),
            const SizedBox(height: 66),
            CustomButton(
                icon: Icons.how_to_vote,
                text: "ابدأ التصويت",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return VotingLists();
                  }));
                }),
            const SizedBox(height: 124),
               const CustomBackButton()
          ],
        ),
      ),
    );
  }
}
