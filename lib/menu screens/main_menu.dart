import 'package:flutter/material.dart';
import 'package:gradproj/login_screen.dart';
import 'package:gradproj/menu%20screens/about.dart';
import 'package:gradproj/menu%20screens/faq.dart';
import 'package:gradproj/menu%20screens/laws.dart';
import 'package:gradproj/menu%20screens/prog.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1.0,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Color.fromRGBO(180, 179, 179, 1),
                      child: Icon(Icons.person,
                          size: 40, color: Color.fromARGB(255, 97, 97, 97)),
                    ),
                    //const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // جعل النصوص تبدأ من اليمين
                      children: [
                        Text(
                          "\nمحمد أحمد عبد الهادي",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text("2000000096",
                            style:TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.start),
                        Text(
                          "الدائرة الانتخابية: عمان الأولى",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                _menuItem(context, Icons.info, "من نحن", const AboutScreen()),
                const Divider(),
                _menuItem(context, Icons.gavel, "التشريعات النافذة",
                    const LawsScreen()),
                const Divider(),
                _menuItem(
                    context, Icons.article, "البرامج", const ProgScreen()),
                const Divider(),
                _menuItem(
                    context, Icons.help, "مركز المساعدة", const FAQPage()),
                    const Divider(),
                _menuItem(
                    context, Icons.logout_outlined, 'تسجيل الخروج', const LoginScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, IconData icon, String title, Widget screen,
      {bool isLogout = false}) {
    return ListTile(
      contentPadding:
          const EdgeInsets.only(right: 10), // جعل المسافة تبدأ من اليمين
      leading: Icon(icon,
          color: isLogout
              ? const Color.fromRGBO(122, 0, 0, 1)
              : const Color.fromARGB(124, 4, 0, 0)),
      title: Text(title,
          style:TextStyle(
              color:
                  isLogout ? const Color.fromRGBO(122, 0, 0, 1) : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal)),
      onTap: () {
        Navigator.pop(context);
        _navigateTo(context, screen);
      },
    );
  }
}