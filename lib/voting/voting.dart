import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // إضافة Firebase Auth
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
  final FirebaseAuth _auth = FirebaseAuth.instance; // إضافة Firebase Auth

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
                  .collection('candidates_info')
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

                var candidates = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    var candidate = candidates[index];
                    String candidateNumber = candidate["number"].toString();
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
                            seat: candidate["seat"] ?? "",
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يجب اختيار مرشح واحد على الأقل"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      WriteBatch batch = _firestore.batch();
                      User? user =
                          _auth.currentUser; // الحصول على المستخدم الحالي

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

                      // تحديث عدد أصوات كل مرشح
                      for (String candidateNumber in selectedCandidates) {
                        var candidateQuery = await _firestore
                            .collection('candidates_info')
                            .where('number', isEqualTo: candidateNumber)
                            .where('listName', isEqualTo: widget.name)
                            .get();

                        if (candidateQuery.docs.isNotEmpty) {
                          var candidateDoc =
                              candidateQuery.docs.first.reference;
                          batch.update(
                              candidateDoc, {'votes': FieldValue.increment(1)});
                          print(
                              'Updated votes for candidate: $candidateNumber');
                        } else {
                          print(
                              'No candidate found with number: $candidateNumber');
                        }
                      }

                      // تحديث عدد الأصوات للقائمة
                      var listQuery = await _firestore
                          .collection('lists_info')
                          .where('name', isEqualTo: widget.name)
                          .get();

                      if (listQuery.docs.isNotEmpty) {
                        var listDoc = listQuery.docs.first.reference;
                        batch.update(listDoc, {
                          'totalVotes':
                              FieldValue.increment(selectedCandidates.length)
                        });
                        print('Updated total votes for list: ${widget.name}');
                      } else {
                        print('No list found with name: ${widget.name}');
                      }

                      // البحث عن المستخدم باستخدام حقل uid داخل الوثيقة
                      var userQuery = await _firestore
                          .collection('users')
                          .where('uid', isEqualTo: userId)
                          .get();

                      if (userQuery.docs.isNotEmpty) {
                        var userDoc = userQuery.docs.first.reference;
                        batch.update(userDoc, {'isVoting': true});
                        print(
                            'Updated isVoting to false for user with UID: $userId');
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

                      // تنفيذ التحديثات دفعة واحدة
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

                      // الانتقال لصفحة التأكيد
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
