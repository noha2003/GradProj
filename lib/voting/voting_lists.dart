import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';

import 'package:gradproj/home.dart';
import 'package:gradproj/voting/lists_page.dart';
import 'package:gradproj/voting/voting.dart';

class VotingLists extends StatelessWidget {
  VotingLists({super.key});

  final List<Map<String, String>> lists = [
    {
      "number": "1",
      "name": "قائمة التجديد",
      "image": "assets/images/tajdeed.png"
    },
    {"number": "2", "name": "قائمة الوفاق", "image": "assets/images/wefaq.png"},
    {
      "number": "3",
      "name": "قائمة النشامى",
      "image": "assets/images/nashama.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Home(
        child: SingleChildScrollView(
      child: Column(children: [
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lists.length,
              itemBuilder: (context, index) {
                return ListsPage(
                    name: lists[index]["name"] ?? "",
                    image: lists[index]["image"] ?? "assets/images/logo.png",
                    number: lists[index]["number"] ?? "0",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CandidateSelectionPage(
                            image: lists[index]["image"] ??
                                "assets/images/logo.png",
                            number: lists[index]["number"] ?? "0",
                          ),
                        ),
                      );
                    });
              }),
        ),
         const SizedBox(height: 10),
        const CustomBackButton(),
        const SizedBox(height: 20),
      ]),
    ));
  }
}
