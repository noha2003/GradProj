import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/home2.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Home_without(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      UserInfo(
                        name: userData?['name'] ?? 'غير معروف',
                        imagePath: userData?['image'],
                      ),
                    ],
                  ),
                  ExpandableCard(
                      title: "الرقم الوطني",
                      content:
                          userData?['nationalId']?.toString() ?? 'غير متوفر'),
                  ExpandableCard(
                      title: "تاريخ الميلاد",
                      content: userData?['birthDate'] ?? 'غير متوفر'),
                  ExpandableCard(
                      title: "الجنس",
                      content: userData?['gender'] ?? 'غير متوفر'),
                  ExpandableCard(
                      title: "الدائرة الانتخابية",
                      content: userData?['electoralDistrict'] ?? 'غير متوفر'),
                  ExpandableCard(
                      title: "حالة المستخدم (مرشح / غير مرشح)",
                      content: userData?['candidateStatus'] ?? 'غير متوفر'),
                  ExpandableCard(
                      title: "رقم الهاتف",
                      content: userData?['phoneNumber'] ?? 'غير متوفر'),
                  ExpandableCard(
                      title: "البريد الالكتروني",
                      content: userData?['email'] ?? 'غير متوفر'),
                  ExpandableCard(title: "كلمة المرور", content: "******"),
                ],
              ),
            ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final String name;
  final String? imagePath; // المسار المخزن في Firestore

  const UserInfo({super.key, required this.name, this.imagePath});

  @override
  Widget build(BuildContext context) {
    bool isAssetImage = imagePath != null && imagePath!.startsWith('assets/');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(122, 0, 0, 1)),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 35,
              backgroundColor: Color.fromRGBO(180, 179, 179, 1),
              backgroundImage: isAssetImage
                  ? AssetImage(imagePath!) // تحميل الصورة من `assets/`
                  : const AssetImage('assets/default-avatar.png')
                      as ImageProvider,
              child: !isAssetImage
                  ? const Icon(Icons.person,
                      size: 40, color: Color.fromARGB(255, 97, 97, 97))
                  : null, // عرض أيقونة افتراضية إذا لم توجد صورة
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Divider(color: Color.fromRGBO(122, 0, 0, 1)),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  const CustomCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(217, 217, 217, 1),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color.fromRGBO(122, 0, 0, 1))),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}

class ExpandableCard extends StatefulWidget {
  final String title;
  final String content;
  const ExpandableCard({super.key, required this.title, required this.content});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        color: const Color.fromRGBO(217, 217, 217, 1),
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color.fromRGBO(122, 0, 0, 1))),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.title,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title == "رقم الهاتف" ||
                      widget.title == "البريد الالكتروني" ||
                      widget.title == "كلمة المرور")
                    const Icon(Icons.edit, color: Colors.black),
                  IconButton(
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(widget.content,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
              ),
          ],
        ),
      ),
    );
  }
}

class EditableCard extends StatelessWidget {
  final String title;
  const EditableCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(217, 217, 217, 1),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color.fromRGBO(122, 0, 0, 1))),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.edit),
      ),
    );
  }
}
