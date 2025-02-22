import 'package:flutter/material.dart';
import 'package:gradproj/back_to_home_button.dart';
import 'package:gradproj/home.dart';

class ElectionResultsScreen extends StatelessWidget {
  final List<Map<String, String>> electionResults = [
    {
      "listNo": "2",
      "listName": "الأقصى الشريف",
      "listVotes": "16180",
      "candidate": "عبد الرحمن حسين محمد العوايش",
      "candidateVotes": "7566"
    },
    {
      "listNo": "5",
      "listName": "العهد",
      "listVotes": "17310",
      "candidate": "أحمد إبراهيم سالم الهميسات",
      "candidateVotes": "6308"
    },
    {
      "listNo": "6",
      "listName": "عمان",
      "listVotes": "17346",
      "candidate": "عطا الله علي قاضي الحنينطي",
      "candidateVotes": "6521"
    },
    {
      "listNo": "8",
      "listName": "الهمة",
      "listVotes": "14202",
      "candidate": "محمد يحيى محمد المحارمة",
      "candidateVotes": "10522"
    },
    {
      "listNo": "10",
      "listName": "جبهة العمل الإسلامي",
      "listVotes": "22133",
      "candidate": "أحمد سليمان عوَض الرُقب",
      "candidateVotes": "17041"
    },
  ];

  ElectionResultsScreen({super.key, required this.districtName});
  final String districtName;
  @override
  Widget build(BuildContext context)
   { var text = Text(
      districtName,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7A0000)),
      textAlign: TextAlign.center,
    );
    return Home(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 26),
              const Text(
                "النتائج النهائية للانتخابات النيابية 2024/",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A0000)),
                textAlign: TextAlign.center,
              ),const SizedBox(height: 13),
               Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: text,
                ),
              const SizedBox(height: 26),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                
                  child: SingleChildScrollView(
                    child: FittedBox(
                      child: DataTable(
                        columnSpacing: 12.0,
                        headingRowColor: WidgetStateColor.resolveWith(
                            (states) => const Color(0xFF7A0000)),
                        headingTextStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        border: const TableBorder(
                          horizontalInside:
                              BorderSide(width: 1.5, color: Colors.white),
                          verticalInside:
                              BorderSide(width: 2, color: Colors.white),
                        ),
                        columns: const [
                          DataColumn(
                              label: SizedBox(
                                  width: 65,
                                  child: Center(child: Text('رقم\nالقائمة')))),
                          DataColumn(
                              label: SizedBox(
                                  width: 160,
                                  child: Center(child: Text('اسم القائمة')))),
                          DataColumn(
                              label: SizedBox(
                                  width: 85,
                                  child: Center(
                                      child: Text('عدد أصوات القائمة')))),
                          DataColumn(
                              label: SizedBox(
                                  width: 155,
                                  child: Center(child: Text('اسم المرشح')))),
                          DataColumn(
                              label: SizedBox(
                                  width: 120,
                                  child:
                                      Center(child: Text('عدد أصوات المرشح')))),
                        ],
                        rows: electionResults.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> item = entry.value;

                          bool isDarkRow = index % 2 == 0;
                          Color rowColor = isDarkRow
                              ? const Color(0xff999596)
                              : const Color(0xFF7A0000);
                          Color textColor = Colors.white;

                          return DataRow(
                            color: WidgetStateColor.resolveWith(
                                (states) => rowColor),
                            cells: [
                              DataCell(Center(
                                child: Text(
                                  item["listNo"]!,
                                  style:
                                      TextStyle(color: textColor, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                              DataCell(Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                      item["listName"]!,
                                      style: TextStyle(
                                          color: textColor, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  item["listVotes"]!,
                                  style:
                                      TextStyle(color: textColor, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                              DataCell(Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                      item["candidate"]!,
                                      style: TextStyle(
                                          color: textColor, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  item["candidateVotes"]!,
                                  style:
                                      TextStyle(color: textColor, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              const BackToHomeButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
