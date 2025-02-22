import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/final_results.dart';
import 'package:gradproj/home.dart';
import 'package:gradproj/voting/view_lists.dart';

class ElectionDistrictsScreen extends StatelessWidget {
  ElectionDistrictsScreen({super.key, required this.forView});
  final bool forView;

  final List<Map<String, dynamic>> districtsData = [
    {"name": "العاصمة - الدائرة الانتخابية الاولى", "id": 1},
    {"name": "العاصمة - الدائرة الانتخابية الثانية", "id": 2},
    {"name": "العاصمة - الدائرة الانتخابية الثالثة", "id": 3},
    {"name": "العاصمة - الدائرة الانتخابية الرابعة", "id": 4},
    {"name": "العاصمة - الدائرة الانتخابية الخامسة", "id": 5},
    {"name": "البادية الشمالية", "id": 6},
    {"name": "البادية الوسطى", "id": 7},
    {"name": "البادية الجنوبية", "id": 8},
    {"name": "اربد-الدائرة الانتخابية الأولى", "id": 9},
    {"name": "اربد-الدائرة الانتخابية الثانية", "id": 10},
    {"name": "اربد-الدائرة الانتخابية الثالثة", "id": 11},
    {"name": "اربد-الدائرة الانتخابية الرابعة", "id": 12},
    {"name": "الزرقاء-الدائرة الانتخابية الأولى", "id": 13},
    {"name": "الزرقاء-الدائرة الانتخابية الثانية", "id": 14},
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
            child: forView? const Text(
              "اختر الدائرة الانتخابية",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A0000)),
              textAlign: TextAlign.center,
            ):const Text(
              "النتائج النهائية للانتخابات النيابية\n 2024",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A0000)),
              textAlign: TextAlign.center,
            ),
          ),
             ListView.builder(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return forView
                                 ? ElectionListsScreen(
                                   districtName: districtsData[index]["name"])
                                :ElectionResultsScreen(
                                   districtName: districtsData[index]["name"]) ;
                            },
                          ),
                        );
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
}
