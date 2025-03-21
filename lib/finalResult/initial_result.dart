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
    try {
      QuerySnapshot listsSnapshot = await _firestore
          .collection('election_lists')
          .where('district', isEqualTo: widget.districtName)
          .get();

      Map<String, Map<String, dynamic>> results = {};

      for (var listDoc in listsSnapshot.docs) {
        String listName = listDoc["name"];
        String listNumber = listDoc["number"];

        QuerySnapshot candidatesSnapshot = await _firestore
            .collection('candidates_info')
            .where('listName', isEqualTo: listName)
            .get();

        int listVotes = 0;
        List<Map<String, dynamic>> candidates = [];

        for (var candidate in candidatesSnapshot.docs) {
          int candidateVotes = candidate["votes"] ?? 0;
          listVotes += candidateVotes;

          candidates.add({
            "name": candidate["name"],
            "votes": candidateVotes,
          });
        }

        // Add the list data to results map with listName as key
        results[listName] = {
          "number": listNumber,
          "totalVotes": listVotes,
          "candidates": candidates,
        };

        try {
          await _firestore
              .collection('election_lists')
              .doc(listDoc.id)
              .update({"totalVotes": listVotes});
        } catch (e) {
          print("خطأ في تحديث totalVotes: $e");
        }
      }

      setState(() {
        electionResults = results; // Assign the map directly
      });
      print("✅ تم جلب البيانات بنجاح");
    } catch (e) {
      print("❌ خطأ أثناء جلب النتائج: $e");
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
                    ? const Center(child: CircularProgressIndicator())
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
                                    'القائمة: $listName (رقم ${listData["number"]}) - إجمالي الأصوات: ${listData["totalVotes"]}',
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
