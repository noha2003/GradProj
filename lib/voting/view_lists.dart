import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/voting/candidates.dart';

import '../home.dart';
import 'lists_page.dart'; // افتراض أن ListsPage معرف مسبقًا

class ElectionListsScreen extends StatefulWidget {
  final String districtName;
  const ElectionListsScreen({super.key, required this.districtName});

  @override
  _ElectionListsScreenState createState() => _ElectionListsScreenState();
}

class _ElectionListsScreenState extends State<ElectionListsScreen> {
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
                    String listName = listData["listName"] ?? "قائمة بدون اسم";
                    String image =
                        listData["image"] ?? "assets/images/logo.png";
                    // الترقيم التلقائي بناءً على موقع القائمة
                    String listNumber = (index + 1).toString();

                    return ListsPage(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Candidates(
                                image: image,
                                listName: listName,
                                num: listNumber,
                              );
                            },
                          ),
                        );
                      },
                      name: listName,
                      image: image,
                      number: listNumber,
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
