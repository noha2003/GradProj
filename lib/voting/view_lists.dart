import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/voting/candidates.dart';

import '../home.dart';
import 'lists_page.dart';

class ElectionListsScreen extends StatelessWidget {
  ElectionListsScreen({super.key, required this.districtName});
  final String districtName;
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
    var text = Text(
      districtName,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7A0000)),
      textAlign: TextAlign.center,
    );
    return Home(
        child: SingleChildScrollView(
      child: Column(children: [
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
          child: text,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lists.length,
              itemBuilder: (context, index) {
                return ListsPage(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Candidates(
                            image: lists[index]["image"] ?? "",
                            listName: lists[index]["name"] ?? "",
                            num: lists[index]["number"] ?? "3",
                          );
                        },
                      ));
                    },
                    name: lists[index]["name"] ?? "",
                    image: lists[index]["image"] ?? "assets/images/logo.png",
                    number: lists[index]["number"] ?? "3");
              }),
        ),
        const CustomBackButton(),
        const SizedBox(height: 5),
      ]),
    ));
  }
}
