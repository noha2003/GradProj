import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/submit.dart';
import 'package:gradproj/voting/candidate_card.dart';
import 'package:gradproj/voting/image_logo.dart';
import 'package:gradproj/voting/submit_voting.dart';

class CandidateSelectionPage extends StatefulWidget {
  final String image;
  final String name; // اسم القائمة الانتخابية

  const CandidateSelectionPage({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  _CandidateSelectionPageState createState() => _CandidateSelectionPageState();
}

class _CandidateSelectionPageState extends State<CandidateSelectionPage> {
  Set<String> selectedCandidates = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Home_without(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 11),
            ImageLogo(imagePath: widget.image),
            const SizedBox(height: 10),
            const Text(
              "للتصويت يمكنك إختيار مرشح واحد أو أكثر",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A0000),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: _firestore
                  .collection('approved_list')
                  .where('listName', isEqualTo: widget.name)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("لا يوجد مرشحون في هذه القائمة"));
                }

                var listDoc = snapshot.data!.docs.first;
                List<dynamic> members = listDoc["members"] ?? [];
                String constituency = listDoc["constituency"] ?? "";
                String listCode = listDoc["listCode"] ?? "";
                List<Map<String, dynamic>> candidates = [];
                for (int i = 0; i < members.length; i++) {
                  candidates.add({
                    "number": (i + 1).toString(),
                    "name": members[i]["name"] ?? "مرشح بدون اسم",
                  });
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    var candidate = candidates[index];
                    String candidateNumber = candidate["number"];
                    bool isSelected =
                        selectedCandidates.contains(candidateNumber);

                    return Row(
                      children: [
                        const Spacer(flex: 1),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: const Color(0xFF7A0000),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedCandidates.remove(candidateNumber);
                              } else {
                                selectedCandidates.add(candidateNumber);
                              }
                            });
                          },
                          child: CandidateCard(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedCandidates.remove(candidateNumber);
                                } else {
                                  selectedCandidates.add(candidateNumber);
                                }
                              });
                            },
                            name: candidate["name"] ?? "",
                            number: candidateNumber,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 15),
            Center(
              child: Row(
                children: [
                  const Spacer(flex: 1),
                  const CustomBackButton(),
                  const SizedBox(width: 10),
                  SubmitButton(
                    onTap: () async {
                      if (selectedCandidates.isEmpty) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.scale,
                          title: 'خطأ',
                          desc: 'يجب اختيار مرشح واحد على الأقل',
                          btnOkText: 'حسنًا',
                          btnOkColor: Colors.red,
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      WriteBatch batch = _firestore.batch();
                      User? user = _auth.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يجب تسجيل الدخول أولاً"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      String userId = user.uid;
                      print('Current User ID from FirebaseAuth: $userId');

                      // جلب بيانات القائمة
                      var listQuery = await _firestore
                          .collection('approved_list')
                          .where('listName', isEqualTo: widget.name)
                          .get();

                      if (listQuery.docs.isEmpty) {
                        print('No list found with name: ${widget.name}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("القائمة غير موجودة"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      var listDoc = listQuery.docs.first;
                      String constituency = listDoc["constituency"] ?? "";
                      String listCode = listDoc["listCode"] ?? "";
                      List<dynamic> members = listDoc["members"] ?? [];

                      // جلب أو إنشاء وثيقة نتائج الدائرة في election_results
                      var resultQuery = await _firestore
                          .collection('election_results')
                          .where('constituency', isEqualTo: constituency)
                          .get();

                      DocumentReference resultDocRef;
                      if (resultQuery.docs.isEmpty) {
                        // إنشاء وثيقة جديدة إذا لم تكن موجودة
                        resultDocRef =
                            _firestore.collection('election_results').doc();
                        await resultDocRef.set({
                          'constituency': constituency,
                          'lists': [],
                        });
                      } else {
                        resultDocRef = resultQuery.docs.first.reference;
                      }

                      var resultDoc = await resultDocRef.get();
                      List<dynamic> lists = resultDoc.exists
                          ? (resultDoc.data()
                                  as Map<String, dynamic>)['lists'] ??
                              []
                          : [];

                      int listIndex = lists.indexWhere(
                          (list) => list['listName'] == widget.name);

                      if (listIndex == -1) {
                        lists.add({
                          'listName': widget.name,
                          'listCode': listCode,
                          'totalVotes': selectedCandidates.length,
                          'members': members.map((member) {
                            int memberIndex = members.indexOf(member) + 1;
                            return {
                              'name': member['name'] ?? "مرشح بدون اسم",
                              'votes': selectedCandidates
                                      .contains(memberIndex.toString())
                                  ? 1
                                  : 0,
                            };
                          }).toList(),
                        });
                      } else {
                        lists[listIndex]['totalVotes'] =
                            (lists[listIndex]['totalVotes'] ?? 0) +
                                selectedCandidates.length;
                        for (var member in lists[listIndex]['members']) {
                          int memberIndex =
                              lists[listIndex]['members'].indexOf(member) + 1;
                          if (selectedCandidates
                              .contains(memberIndex.toString())) {
                            member['votes'] = (member['votes'] ?? 0) + 1;
                          }
                        }
                      }

                      batch.set(
                        resultDocRef,
                        {
                          'constituency': constituency,
                          'lists': lists,
                        },
                        SetOptions(merge: true),
                      );

                      var userQuery = await _firestore
                          .collection('users')
                          .where('uid', isEqualTo: userId)
                          .get();

                      if (userQuery.docs.isNotEmpty) {
                        var userDoc = userQuery.docs.first.reference;
                        batch.update(userDoc, {'isVoting': true});
                        print(
                            'Updated isVoting to true for user with UID: $userId');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "لا يمكن تحديث حالة التصويت: المستخدم غير موجود"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        print(
                            'No user found with UID field: $userId in users collection');
                        return;
                      }

                      try {
                        await batch.commit();
                        print('Batch commit completed successfully');
                      } catch (e) {
                        print('Error during batch commit: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("حدث خطأ أثناء التصويت: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubmitVoting()),
                      );
                    },
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
