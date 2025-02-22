import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/home.dart';

class ImportantDates extends StatelessWidget {
  final List<Map<String, String>> electionSchedule = [
    {"index": "1", "event": "قرار إجراء الانتخابات", "date": "24/04/2024"},
    {"index": "2", "event": "إنشاء قوائم الكتل", "date": "26/06/2024"},
    {"index": "3", "event": "موافقة/رفض القوائم", "date": "10/07/2024"},
    {
      "index": "4",
      "event": "بدء ترشح أعضاء القوائم الانتخابية",
      "date": "20/07/2024"
    },
    {
      "index": "5",
      "event": "أقل عمر للمرشح 25 عامًا",
      "date": "مواليد ما قبل 06/1999"
    },
    {"index": "6", "event": "موافقة/رفض طلبات الترشيح", "date": "30/07/2024"},
    {"index": "7", "event": "بدء الدعاية الانتخابية", "date": "9/8/2024"},
    {
      "index": "8",
      "event": "الصعود النهائي - الانسحاب من الترشيح",
      "date": "26/08/2024"
    },
    {
      "index": "9",
      "event": "حجب القوائم الانتخابية النهائية",
      "date": "28/08/2024"
    },
    {
      "index": "10",
      "event": "من يحق له الانتخاب",
      "date": "مواليد ما قبل 06/2007"
    },
    {"index": "11", "event": "يوم الاقتراع", "date": "10/09/2024"},
    {"index": "12", "event": "إعلان النتائج النهائية", "date": "11/09/2024"},
  ];

  ImportantDates({super.key});

  @override
  Widget build(BuildContext context) {
    return Home(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            const Text(
              'المواعيد المهمة للانتخابات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: DataTable(
                    columnSpacing: 12.0,
                    headingRowColor: WidgetStateColor.resolveWith(
                        (states) => const Color(0xFF7A0000)),
                    headingTextStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                          width: 1,
                          color: Colors.white), 
                      verticalInside: BorderSide(
                          width: 2,
                          color: Colors.white), 
                    ),
                    columns: const [
                      DataColumn(
                          label: SizedBox(
                              width: 65,
                              child: Center(child: Text('التسلسل')))),
                      DataColumn(
                          label: SizedBox(
                              width: 160,
                              child: Center(child: Text('الإجراء الانتخابي')))),
                      DataColumn(
                          label: SizedBox(
                              width: 85,
                              child: Center(child: Text('التاريخ')))),
                    ],
                    rows: electionSchedule.map((item) {
                      return DataRow(
                        color: WidgetStateColor.resolveWith((states) =>
                            (electionSchedule.indexOf(item) % 2 == 0)
                                ? const Color(0xff999596)
                                : const Color(0xFF7A0000)),
                        cells: [
                          DataCell(SizedBox(
                              width: 65,
                              child: Center(
                                 child: Text(item["index"]!,
                                 style: const TextStyle(
                                color: Colors.white))))),
                          DataCell(SizedBox(
                              width: 160,
                              child: Center(
                                child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                Text(item["event"]!,
                                textAlign: TextAlign.center,
                               style: const TextStyle(
                               color: Colors.white))
                                  ],
                                ),
                              ))),
                          DataCell(SizedBox(
                              width: 85,
                              child: Center(
                               child: Text(item["date"]!,
                               style: const TextStyle(
                                color: Colors.white))))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const CustomBackButton(),
          ],
        ),
      ),
    );
  }
}
