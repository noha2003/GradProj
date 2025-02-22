import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/voting/candidate_card.dart';
import 'package:gradproj/home.dart';
import 'package:gradproj/voting/image_logo.dart';
import 'package:gradproj/submit.dart';
import 'package:gradproj/voting/submit_voting.dart';

class CandidateSelectionPage extends StatefulWidget {
  final String image;
  final String number;
  const CandidateSelectionPage(
      {super.key, required this.image, required this.number});

  @override
  // ignore: library_private_types_in_public_api
  _CandidateSelectionPageState createState() => _CandidateSelectionPageState();
}

class _CandidateSelectionPageState extends State<CandidateSelectionPage> {
  Set<String> selectedCandidates = {};

  final List<Map<String, String>> candidates = [
    {
      "name": "نبال محمد  سنقرط",
      "seat": "المقعد : تنافس",
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
    return Home(
        child: SingleChildScrollView(
      child: Column(children: [
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: candidates.length,
              itemBuilder: (context, index) {
                String candidateNumber = candidates[index]["number"] ?? "0";
                bool isSelected = selectedCandidates.contains(candidateNumber);
                return Row(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: isSelected
                          ? const Icon(Icons.check_box,
                              color: Color(0xFF7A0000), size: 30)
                          : const Icon(Icons.check_box_outline_blank,
                              color: Color(0xFF7A0000), size: 30),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        name: candidates[index]["name"] ?? "",
                        seat: candidates[index]["seat"] ?? "",
                        number: candidates[index]["number"] ?? "0",
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                  ],
                );
              }),
        ),
        Center(
          child: Row(children: [
            const Spacer(flex: 1),
            const CustomBackButton(),
            const SizedBox(width: 10),
            SubmitButton(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const SubmitVoting();
                  },
                ));
              },
            ),
           const Spacer(flex: 1)
          ]),
        ),
        const SizedBox(height: 30),
      ]),
    ));
  }
}

/*import 'package:flutter/material.dart';
import 'package:gradproj/candidate_card.dart';
import 'package:gradproj/candinfo.dart';
import 'package:gradproj/home.dart';
import 'package:gradproj/image_logo.dart';
import 'package:gradproj/list_info.dart';
import 'package:gradproj/main_page.dart';

class Voting extends StatelessWidget {
  const Voting({super.key, required this.list});
  final ListInfo list;
  final List<Candinfo> candidatesInfo = const [
    Candinfo(
      name: "نيال محمد سنقرط",
      seat: "تنافس",
      number: "1",
    ),
    Candinfo(
      name: "نوران رباح الخطيب",
      seat: "تنافس",
      number: "2",
    ),
    Candinfo(
      name: "نجح محمد صالح",
      seat: "كوتا المرأة",
      number: "3",
    ),
    Candinfo(
      name: "محمد خالد العزو",
      seat: "تنافس",
      number: "4",
    ),
  ];
  final bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Home(
      child: Column(
        children: [
          const SizedBox(height: 11),
          ImageLogo(imagePath: list.image),
          const SizedBox(height: 10),
          Text(
            "أعضاء قائمة ${list.listName}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7A0000),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: candidatesInfo.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    // ✅
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A0000),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 24)
                          : null, // إذا لم يكن محددًا، لا نعرض أي شيء
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CandidateCard(
                      candidate: candidatesInfo[index],
                      onTap: () {
                        () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const MainPage();
                          }));
                          // Handle navigation or action here
                        };
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/ 