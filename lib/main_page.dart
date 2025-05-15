import 'package:cloud_firestore/cloud_firestore.dart'; // إضافة Firestore
import 'package:firebase_auth/firebase_auth.dart'; // إضافة Firebase Auth
import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/election_district.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/voting/custom_button.dart';
import 'package:gradproj/voting/voting_lists.dart';

class MainPage extends StatefulWidget {
  // تغيير إلى StatefulWidget
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = true;
  bool _hasVoted = false;

  @override
  void initState() {
    super.initState();
    _checkVotingStatus();
  }

  Future<void> _checkVotingStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _hasVoted = userDoc.get('isVoting') ?? false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking voting status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showHasVotedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لقد قمت بالتصويت من قبل'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Home_without(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionDistrictsScreen(
                            screenType: ElectionScreenType.viewLists),
                      ));
                },
              ),
            ),
            const SizedBox(height: 66),
            CustomButton(
              icon: Icons.how_to_vote,
              text: "ابدأ التصويت",
              onTap: _hasVoted
                  ? _showHasVotedMessage
                  : () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const VotingLists();
                      }));
                    },
              isDisabled:
                  _hasVoted, // افترض أن CustomButton يدعم خاصية isDisabled
            ),
            const SizedBox(height: 124),
            const CustomBackButton()
          ],
        ),
      ),
    );
  }
}
