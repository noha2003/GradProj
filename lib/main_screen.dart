import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/apply%20election/election1.dart';
import 'package:gradproj/create%20list/create_list.dart';
import 'package:gradproj/finalResult/finalmainpage.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/important_dates.dart';
import 'package:gradproj/main_page.dart';
import 'package:gradproj/menu%20screens/main_menu.dart';
import 'package:gradproj/nav%20screens/bar.dart';
import 'package:gradproj/nav%20screens/notification.dart';
import 'package:gradproj/nav%20screens/profile.dart';
import 'package:gradproj/withdraw/withdraw_main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 3;

  final List<Widget> _screens = [
    const MenuScreen(),
    const ProfileScreen(),
    const NotificationScreen(),
    const Home_without(child: HomeScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNav(
        onTabSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<bool> _hasAppliedBefore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      String userId = user.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('User $userId has already applied');
        return true; // المستخدم لديه طلب سابق
      }
      print('No application found for user $userId');
      return false; // لا يوجد طلب سابق
    } catch (e) {
      print('Error checking application status: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {"icon": Icons.how_to_reg_rounded, "label": "الترشح للانتخابات"},
      {"icon": Icons.how_to_vote_rounded, "label": "التصويت"},
      {"icon": Icons.ballot_outlined, "label": "إنشاء قائمة انتخابية"},
      {"icon": Icons.group_remove_rounded, "label": "الانسحاب من الانتخابات"},
      {"icon": Icons.calendar_month_rounded, "label": "مواعيد مهمة"},
      {"icon": Icons.bar_chart, "label": "الاطلاع على النتائج النهائية"},
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 20, left: 20, right: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1.1,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              if (menuItems[index]['label'] == 'الانسحاب من الانتخابات') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WithdrawalScreen()),
                );
              } else if (menuItems[index]['label'] == 'الترشح للانتخابات') {
                bool hasApplied = await _hasAppliedBefore();
                if (hasApplied) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.bottomSlide,
                    title: 'تم التقديم مسبقًا',
                    desc:
                        'لقد قمت بإرسال طلب من قبل ولا يمكنك التقديم مرة أخرى',
                    btnOkText: 'حسنًا',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ElectionCodeScreen()),
                  );
                }
              } else if (menuItems[index]['label'] == "التصويت") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              } else if (menuItems[index]['label'] == "مواعيد مهمة") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImportantDates()),
                );
              } else if (menuItems[index]['label'] ==
                  "الاطلاع على النتائج النهائية") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FinalMainPage()),
                );
              } else if (menuItems[index]['label'] == 'إنشاء قائمة انتخابية') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateList()),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 217, 217, 1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: const Color.fromRGBO(122, 0, 0, 1), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    menuItems[index]['icon'],
                    size: 60,
                    color: const Color.fromARGB(177, 0, 0, 0),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    menuItems[index]['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color.fromRGBO(122, 0, 0, 1),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
