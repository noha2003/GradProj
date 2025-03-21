import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/voting/candidate_card.dart';
import 'package:gradproj/voting/image_logo.dart';
import 'package:gradproj/voting/voting.dart';

class Candidates extends StatelessWidget {
  final String? name;
  final String? seat;
  final String? number;
  Candidates(
      {super.key,
      this.name,
      this.seat,
      this.number,
      required this.image,
      required this.listName,
      required this.num});
  final String image;
  final String listName;
  final String num;
  final List<Map<String, String>> candidatesInfo = [
    {
      "name": "نيال محمد سنقرط",
      "seat": "تنافس",
      "number": "1",
    },
    {
      "name": "نوران رباح الخطيب",
      "seat": "تنافس",
      "number": "2",
    },
    {
      "name": "نجح محمد صالح",
      "seat": "كوتا المرأة",
      "number": "3",
    },
    {
      "name": "محمد خالد العزو",
      "seat": "تنافس",
      "number": "4",
    }
  ];

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: candidatesInfo.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: CandidateCard(
                      onTap: () {
                        () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return CandidateSelectionPage(
                                image: image,
                                name: '',
                              );
                            },
                          ));
                          // Handle navigation or action here
                        };
                      },
                      name: candidatesInfo[index]["name"] ?? "",
                      seat: candidatesInfo[index]["seat"] ?? "",
                      number: candidatesInfo[index]["number"] ?? "0",
                    ),
                  );
                },
              ),
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
