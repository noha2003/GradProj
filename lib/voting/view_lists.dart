import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/voting/candidates.dart';

import '../home.dart';
import 'lists_page.dart';

class ElectionListsScreen extends StatefulWidget {
  final String districtName;
  const ElectionListsScreen({super.key, required this.districtName});

  @override
  _ElectionListsScreenState createState() => _ElectionListsScreenState();
}

class _ElectionListsScreenState extends State<ElectionListsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // حذف updateElectionList لأننا لم نعد نحتاجها مباشرة (يمكن إعادة إضافتها إذا لزم الأمر)
  Future<List<Map<String, dynamic>>> _fetchLists() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('approved_list')
        .where('constituency', isEqualTo: widget.districtName)
        .get();

    return querySnapshot.docs
        .map((doc) => {
              "number":
                  doc["listCode"]?.toString() ?? "", // استخدام listCode كبديل
              "name": doc["listName"] ?? "",
              "image": doc["image"] ?? "assets/images/logo.png",
            })
        .toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Home(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 33),
              child: Text(
                "القوائم الانتخابية التابعة لدائرة",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A0000)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                widget.districtName,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A0000)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('approved_list')
                  .where('constituency', isEqualTo: widget.districtName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("حدث خطأ أثناء تحميل البيانات"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("لا توجد قوائم انتخابية متاحة"));
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var listData = docs[index].data() as Map<String, dynamic>;

                    return ListsPage(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Candidates(
                                image: listData["image"] ??
                                    "assets/images/logo.png",
                                listName: listData["listName"] ?? "",
                                num: listData["listCode"]?.toString() ?? "",
                              );
                            },
                          ),
                        );
                      },
                      name: listData["listName"] ?? "",
                      image: listData["image"] ?? "assets/images/logo.png",
                      number: listData["listCode"]?.toString() ?? "",
                    );
                  },
                );
              },
            ),
            const CustomBackButton(),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
