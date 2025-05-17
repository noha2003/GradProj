import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/voting/candidate_card.dart';
import 'package:gradproj/voting/image_logo.dart';

class Candidates extends StatelessWidget {
  final String image;
  final String listName;
  final String num;

  Candidates({
    super.key,
    required this.image,
    required this.listName,
    required this.num,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Home_without(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 11),
            ImageLogo(imagePath: image),
            const SizedBox(height: 10),
            Text(
              "أعضاء $listName",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A0000),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: _firestore
                  .collection('approved_list')
                  .where('listName', isEqualTo: listName)
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
                List<Map<String, dynamic>> candidates = [];
                var uploadedFiles = listDoc["uploadedFiles"] ?? {};
                String candidateImage =
                    uploadedFiles["صورة عن الهوية الشخصية"] ??
                        "assets/images/logo.png";

                for (int i = 0; i < members.length; i++) {
                  candidates.add({
                    "number": (i + 1).toString(),
                    "name": members[i]["name"] ?? "مرشح بدون اسم",
                    "seat": members[i]["seat"] ?? "",
                    "image": candidateImage,
                  });
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: candidates.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: CandidateCard(
                          onTap: () {},
                          name: candidates[index]["name"] ?? "",
                          number: candidates[index]["number"] ?? "0",
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            const CustomBackButton(),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
