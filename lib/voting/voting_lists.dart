import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 استيراد Firestore
import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/voting/lists_page.dart';
import 'package:gradproj/voting/voting.dart';

class VotingLists extends StatefulWidget {
  const VotingLists({super.key});

  @override
  _VotingListsState createState() => _VotingListsState();
}

class _VotingListsState extends State<VotingLists> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchLists() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('election_lists').get();

    return querySnapshot.docs
        .map((doc) => {
              "number": doc["number"].toString(),
              "name": doc["name"],
              "image": doc["image"]
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Home_without(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 33),
              child: Text(
                "للتصويت الرجاء اختيار قائمة انتخابية",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A0000)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchLists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("حدث خطأ أثناء تحميل البيانات"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("لا توجد قوائم انتخابية متاحة"));
                }

                List<Map<String, dynamic>> lists = snapshot.data!;
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      return ListsPage(
                        name: lists[index]["name"] ?? "",
                        image:
                            lists[index]["image"] ?? "assets/images/logo.png",
                        number: lists[index]["number"] ?? "0",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CandidateSelectionPage(
                                image: lists[index]["image"] ??
                                    "assets/images/logo.png",
                                name: lists[index]["name"] ?? "",
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const CustomBackButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
