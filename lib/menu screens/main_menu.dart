import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/login_screen.dart';
import 'package:gradproj/menu%20screens/about.dart';
import 'package:gradproj/menu%20screens/faq.dart';
import 'package:gradproj/menu%20screens/laws.dart';
import 'package:gradproj/menu%20screens/prog.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? _documentId; // لتخزين documentId الحقيقي

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      setState(() {
        isLoading = true;
      });

      User? user = _auth.currentUser;
      if (user != null) {
        // البحث عن المستند الذي يحتوي على حقل uid يتطابق مع user.uid
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var doc = querySnapshot.docs.first;
          _documentId = doc.id; // تخزين documentId الحقيقي
          setState(() {
            userData = doc.data() as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لم يتم العثور على بيانات المستخدم')),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لم يتم تسجيل الدخول')),
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء جلب البيانات')),
      );
    }
  }

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
            padding:
                const EdgeInsets.only(left: 16, top: 40, right: 16, bottom: 16),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor:
                                const Color.fromRGBO(180, 179, 179, 1),
                            backgroundImage: (userData?['image'] != null &&
                                    userData?['image'].isNotEmpty)
                                ? AssetImage(userData?[
                                    'image']) // تحميل الصورة من المسار المخزن في Firestore
                                : const AssetImage('assets/default-avatar.png'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\n${userData?['name'] ?? 'غير معروف'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                userData?['nationalId']?.toString() ?? 'غير متوفر',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "الدائرة الانتخابية: ${userData?['electoralDistrict'] ?? 'غير متوفر'}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      _menuItem(
                          context, Icons.info, "من نحن", const AboutScreen()),
                      const Divider(),
                      _menuItem(context, Icons.gavel, "التشريعات النافذة",
                          const LawsScreen()),
                      const Divider(),
                      _menuItem(context, Icons.article, "البرامج",
                          const ProgScreen()),
                      const Divider(),
                      _menuItem(context, Icons.help, "مركز المساعدة",
                          const FAQPage()),
                      const Divider(),
                      _menuItem(context, Icons.logout_outlined, 'تسجيل الخروج',
                          const LoginScreen(),
                          isLogout: true),
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
      contentPadding: const EdgeInsets.only(right: 10),
      leading: Icon(icon,
          color: isLogout
              ? const Color.fromRGBO(122, 0, 0, 1)
              : const Color.fromARGB(124, 4, 0, 0)),
      title: Text(title,
          style: TextStyle(
              color:
                  isLogout ? const Color.fromRGBO(122, 0, 0, 1) : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal)),
      onTap: () {
        _navigateTo(context, screen);
      },
    );
  }
}
