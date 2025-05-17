import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/finalResult/final_results.dart';
import 'package:gradproj/finalResult/initial_result.dart';
import 'package:gradproj/home.dart';
import 'package:gradproj/voting/view_lists.dart'; // Correct import for ElectionListsScreen

enum ElectionScreenType { viewLists, initialResults, finalResults }

class ElectionDistrictsScreenF extends StatelessWidget {
  final ElectionScreenType screenType;

  ElectionDistrictsScreenF({super.key, required this.screenType});

  final List<Map<String, dynamic>> districtsData = [
    {"name": "العاصمة - الدائرة الانتخابية الأولى", "id": 1},
    {"name": "العاصمة - الدائرة الانتخابية الثانية", "id": 2},
    {"name": "العاصمة - الدائرة الانتخابية الثالثة", "id": 3},
    {"name": "العاصمة - الدائرة الانتخابية الرابعة", "id": 4},
    {"name": "العاصمة - الدائرة الانتخابية الخامسة", "id": 5},
    {"name": "البادية الشمالية", "id": 6},
    {"name": "البادية الوسطى", "id": 7},
    {"name": "البادية الجنوبية", "id": 8},
    {"name": "إربد - الدائرة الانتخابية الأولى", "id": 9},
    {"name": "إربد - الدائرة الانتخابية الثانية", "id": 10},
    {"name": "إربد - الدائرة الانتخابية الثالثة", "id": 11},
    {"name": "إربد - الدائرة الانتخابية الرابعة", "id": 12},
    {"name": "الزرقاء - الدائرة الانتخابية الأولى", "id": 13},
    {"name": "الزرقاء - الدائرة الانتخابية الثانية", "id": 14},
    {"name": "البلقاء", "id": 15},
    {"name": "الكرك", "id": 16},
    {"name": "الطفيلة", "id": 17},
    {"name": "جرش", "id": 18},
    {"name": "مادبا", "id": 19},
    {"name": "معان", "id": 20},
    {"name": "عجلون", "id": 21}
  ];

  @override
  Widget build(BuildContext context) {
    return Home(
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 33),
            child: Text(
              _getTitle(),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A0000)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: districtsData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 6.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(345, 98),
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Color(0xFF7A0000), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    _navigateToNextScreen(
                        context, districtsData[index]["name"]);
                  },
                  child: Text(districtsData[index]["name"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const CustomBackButton(),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  String _getTitle() {
    switch (screenType) {
      case ElectionScreenType.viewLists:
        return "اختر الدائرة الانتخابية";
      case ElectionScreenType.initialResults:
        return "النتائج الأولية للانتخابات 2028";
      case ElectionScreenType.finalResults:
        return "النتائج النهائية للسنوات السابقة";
      default:
        return "";
    }
  }

  void _navigateToNextScreen(BuildContext context, String districtName) {
    Widget nextScreen;
    switch (screenType) {
      case ElectionScreenType.viewLists:
        nextScreen = ElectionListsScreen(districtName: districtName);
        break;
      case ElectionScreenType.initialResults:
        nextScreen = InitialResults(districtName: districtName);
        break;
      case ElectionScreenType.finalResults:
        nextScreen = ElectionResultsScreen(districtName: districtName);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    ).then((value) {
      print("تم العودة من الشاشة التالية");
    }).catchError((error) {
      print("خطأ أثناء التنقل: $error");
    });
  }
}
