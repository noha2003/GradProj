import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/back_to_home_button.dart';
import 'package:gradproj/home2.dart';

class InitialResults extends StatefulWidget {
  final String districtName;

  const InitialResults({super.key, required this.districtName});

  @override
  _InitialResultsState createState() => _InitialResultsState();
}

class _InitialResultsState extends State<InitialResults> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, Map<String, dynamic>> electionResults = {};

  @override
  void initState() {
    super.initState();
    fetchElectionResults();
  }

  Future<void> fetchElectionResults() async {
    print("جارٍ جلب النتائج للدائرة: ${widget.districtName}");
    try {
      // الخطوة 1: استرجاع القوائم من approved_list بناءً على الدائرة
      QuerySnapshot listsSnapshot = await _firestore
          .collection('approved_list')
          .where('constituency', isEqualTo: widget.districtName)
          .get();

      print("عدد الوثائق في approved_list: ${listsSnapshot.docs.length}");
      if (listsSnapshot.docs.isEmpty) {
        print("لا توجد قوائم في هذه الدائرة: ${widget.districtName}");
        setState(() {
          electionResults = {};
        });
        return;
      }

      Map<String, Map<String, dynamic>> results = {};

      // الخطوة 2: استرجاع الأصوات من election_results (إذا كانت موجودة)
      QuerySnapshot resultSnapshot = await _firestore
          .collection('election_results')
          .where('constituency', isEqualTo: widget.districtName)
          .get();

      print("عدد الوثائق في election_results: ${resultSnapshot.docs.length}");
      Map<String, Map<String, dynamic>> votesData = {};
      if (resultSnapshot.docs.isNotEmpty) {
        var resultDoc = resultSnapshot.docs.first;
        var data = resultDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          List<dynamic>? lists = data['lists'];
          print("تم العثور على قوائم في election_results: ${lists?.length}");
          if (lists != null) {
            for (var list in lists) {
              var listData = list as Map<String, dynamic>?;
              if (listData != null) {
                String? listName = listData['listName'] as String?;
                if (listName != null) {
                  votesData[listName] = {
                    "totalVotes": listData['totalVotes'] ?? 0,
                    "members": Map.fromIterable(
                      (listData['members'] ?? []) as Iterable,
                      key: (member) =>
                          (member as Map<String, dynamic>?)?['name'] ?? '',
                      value: (member) =>
                          (member as Map<String, dynamic>?)?['votes'] ?? 0,
                    ),
                  };
                }
              }
            }
          }
        }
      }

      // الخطوة 3: بناء النتائج بناءً على القوائم من approved_list
      for (var listDoc in listsSnapshot.docs) {
        var data = listDoc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? listName = data['listName'] as String?;
          if (listName != null) {
            List<dynamic>? members = data['members'];
            print(
                "تم العثور على members للقائمة $listName: ${members?.length}");
            if (members != null) {
              // تحويل members إلى قائمة من المرشحين مع الأصوات
              List<Map<String, dynamic>> candidates = members.map((member) {
                var memberData = member as Map<String, dynamic>?;
                String candidateName = memberData?['name'] ?? "مرشح بدون اسم";
                int candidateVotes = votesData.containsKey(listName) &&
                        votesData[listName]?["members"]
                                .containsKey(candidateName) ==
                            true
                    ? (votesData[listName]?["members"][candidateName] ?? 0)
                    : 0;

                return {
                  "name": candidateName,
                  "votes": candidateVotes,
                };
              }).toList();

              int totalVotes = votesData.containsKey(listName)
                  ? (votesData[listName]?["totalVotes"] ?? 0)
                  : 0;

              results[listName] = {
                "number": data['listCode'] ??
                    "", // لا يزال يتم إنشاؤه للتوافق مع البيانات
                "totalVotes": totalVotes,
                "candidates": candidates,
              };
            }
          }
        }
      }

      setState(() {
        electionResults = results;
      });
      print("✅ تم جلب البيانات بنجاح، عدد القوائم: ${results.length}");
    } catch (e) {
      print("❌ خطأ أثناء جلب النتائج: $e");
      setState(() {
        electionResults = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Home_without(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 26),
              Text(
                "النتائج الأولية - ${widget.districtName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A0000),
                ),
                textAlign: TextAlign.center,
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
                        child: Column(
                          children: electionResults.entries.map((entry) {
                            String listName = entry.key;
                            Map<String, dynamic> listData = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'القائمة: $listName - إجمالي الأصوات: ${listData["totalVotes"]}', // إزالة listCode من النص
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF7A0000),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 12.0,
                                      headingRowColor:
                                          WidgetStateColor.resolveWith(
                                        (states) => const Color(0xFF7A0000),
                                      ),
                                      headingTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      border: const TableBorder(
                                        horizontalInside: BorderSide(
                                            width: 1.5, color: Colors.white),
                                        verticalInside: BorderSide(
                                            width: 2, color: Colors.white),
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: SizedBox(
                                            width: 155,
                                            child: Center(
                                                child: Text('اسم المرشح')),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: 120,
                                            child: Center(
                                                child: Text('عدد الأصوات')),
                                          ),
                                        ),
                                      ],
                                      rows: (listData["candidates"]
                                              as List<Map<String, dynamic>>)
                                          .asMap()
                                          .entries
                                          .map((candidateEntry) {
                                        int index = candidateEntry.key;
                                        Map<String, dynamic> candidate =
                                            candidateEntry.value;
                                        bool isDarkRow = index % 2 == 0;
                                        Color rowColor = isDarkRow
                                            ? const Color(0xff999596)
                                            : const Color(0xFF7A0000);
                                        Color textColor = Colors.white;

                                        return DataRow(
                                          color: WidgetStateColor.resolveWith(
                                              (states) => rowColor),
                                          cells: [
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  candidate["name"],
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  candidate["votes"].toString(),
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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
