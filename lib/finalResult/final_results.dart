import 'package:flutter/material.dart';
import 'package:gradproj/back_to_home_button.dart';
import 'package:gradproj/home2.dart';

class ElectionResultsScreen extends StatelessWidget {
  final String districtName;

  // هيكل البيانات المحلية كـ Map
  final Map<String, Map<String, dynamic>> electionResults = {
    "الأقصى الشريف": {
      "listCode": "2",
      "totalVotes": 16180,
      "candidates": [
        {"name": "عبد الرحمن حسين محمد العوايش", "votes": 7566},
      ],
    },
    "العهد": {
      "listCode": "5",
      "totalVotes": 17310,
      "candidates": [
        {"name": "أحمد إبراهيم سالم الهميسات", "votes": 6308},
      ],
    },
    "عمان": {
      "listCode": "6",
      "totalVotes": 17346,
      "candidates": [
        {"name": "عطا الله علي قاضي الحنينطي", "votes": 6521},
      ],
    },
    "الهمة": {
      "listCode": "8",
      "totalVotes": 14202,
      "candidates": [
        {"name": "محمد يحيى محمد المحارمة", "votes": 10522},
      ],
    },
    "جبهة العمل الإسلامي": {
      "listCode": "10",
      "totalVotes": 22133,
      "candidates": [
        {"name": "أحمد سليمان عوَض الرُقب", "votes": 17041},
      ],
    },
  };

  ElectionResultsScreen({super.key, required this.districtName});

  @override
  Widget build(BuildContext context) {
    // إنشاء قائمة موحدة من الصفوف (DataRow) لجميع القوائم
    List<DataRow> allRows = [];
    int rowIndex = 0;

    electionResults.entries.forEach((entry) {
      String listName = entry.key;
      Map<String, dynamic> listData = entry.value;
      List<Map<String, dynamic>> candidates =
          List<Map<String, dynamic>>.from(listData["candidates"]);

      candidates.asMap().forEach((index, candidate) {
        bool isDarkRow = rowIndex % 2 == 0;
        Color rowColor =
            isDarkRow ? const Color(0xff999596) : const Color(0xFF7A0000);
        Color textColor = Colors.white;

        allRows.add(
          DataRow(
            color: WidgetStateColor.resolveWith((states) => rowColor),
            cells: [
              DataCell(
                Center(
                  child: Text(
                    listData["listCode"],
                    style: TextStyle(color: textColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        listName,
                        style: TextStyle(color: textColor, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    listData["totalVotes"].toString(),
                    style: TextStyle(color: textColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        candidate["name"],
                        style: TextStyle(color: textColor, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                Center(
                  child: Text(
                    candidate["votes"].toString(),
                    style: TextStyle(color: textColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
        rowIndex++;
      });
    });

    return Home_without(
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
              ),
              const SizedBox(height: 13),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  districtName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A0000)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 26),
              Expanded(
                child: electionResults.isEmpty
                    ? const Center(
                        child: Text(
                          "لا توجد نتائج متاحة لهذه الدائرة",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF7A0000),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 12.0,
                            headingRowColor: WidgetStateColor.resolveWith(
                              (states) => const Color(0xFF7A0000),
                            ),
                            headingTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  child: Center(child: Text('رقم\nالقائمة')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 160,
                                  child: Center(child: Text('اسم القائمة')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 85,
                                  child: Center(
                                      child: Text('عدد أصوات\n القائمة')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 155,
                                  child: Center(child: Text('اسم المرشح')),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: 120,
                                  child:
                                      Center(child: Text('عدد أصوات المرشح')),
                                ),
                              ),
                            ],
                            rows: allRows,
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
