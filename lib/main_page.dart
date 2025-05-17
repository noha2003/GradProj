import 'package:cloud_firestore/cloud_firestore.dart'; // إضافة Firestore
import 'package:firebase_auth/firebase_auth.dart'; // إضافة Firebase Auth
import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/election_districtF.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/voting/custom_button.dart';
import 'package:gradproj/voting/voting_lists.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = true;
  bool _hasVoted = false;
  String? _electoralDistrict; // To store the user's electoral district

  @override
  void initState() {
    super.initState();
    _checkVotingStatus();
  }

  Future<void> _checkVotingStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      String userId = user.uid;
      print('Current User ID from FirebaseAuth: $userId');

      // Fetch user document using the uid field
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userId)
          .get();

      if (userQuery.docs.isNotEmpty) {
        var userDoc = userQuery.docs.first;
        setState(() {
          _hasVoted = userDoc.get('isVoting') ?? false;
          _electoralDistrict = userDoc.get('electoralDistrict') ?? '';
          _isLoading = false;
        });
        print(
            'User found with UID: $userId, hasVoted: $_hasVoted, electoralDistrict: $_electoralDistrict');
      } else {
        print('No user found with UID field: $userId in users collection');
        setState(() {
          _isLoading = false;
          _hasVoted = false;
          _electoralDistrict = '';
        });
      }
    } catch (e) {
      print('Error checking voting status: $e');
      setState(() {
        _isLoading = false;
        _hasVoted = false;
        _electoralDistrict = '';
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
                      builder: (context) => ElectionDistrictsScreenF(
                        screenType: ElectionScreenType.viewLists,
                      ),
                    ),
                  );
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
                      if (_electoralDistrict != null &&
                          _electoralDistrict!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VotingLists(
                              districtName: _electoralDistrict!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('لا يمكن تحديد الدائرة الانتخابية'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
              isDisabled: _hasVoted,
            ),
            const SizedBox(height: 124),
            const CustomBackButton(),
          ],
        ),
      ),
    );
  }
}
