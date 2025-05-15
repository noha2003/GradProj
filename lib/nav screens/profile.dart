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
  String? _documentId; // لتخزين documentId الحقيقي

  // Controllers للتعديل
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            _phoneController.text = userData?['phoneNumber'] ?? '';
            _emailController.text = userData?['email'] ?? '';
            _passwordController.text = '******'; // كلمة المرور مخفية
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

  Future<void> updateUserData(String field, String value) async {
    if (_documentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('لا يمكن تحديث البيانات: المستند غير موجود')),
      );
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(_documentId)
          .update({field: value});
      setState(() {
        userData?[field] = value;
        if (field == 'phoneNumber') _phoneController.text = value;
        if (field == 'email') _emailController.text = value;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التحديث بنجاح')),
      );
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء التحديث')),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                    content: userData?['nationalId']?.toString() ?? 'غير متوفر',
                    isEditable: false,
                  ),
                  ExpandableCard(
                    title: "تاريخ الميلاد",
                    content: userData?['birthDate'] ?? 'غير متوفر',
                    isEditable: false,
                  ),
                  ExpandableCard(
                    title: "الجنس",
                    content: userData?['gender'] ?? 'غير متوفر',
                    isEditable: false,
                  ),
                  ExpandableCard(
                    title: "الدائرة الانتخابية",
                    content: userData?['electoralDistrict'] ?? 'غير متوفر',
                    isEditable: false,
                  ),
                  ExpandableCard(
                    title: "حالة المستخدم (مرشح / غير مرشح)",
                    content: userData?['status'] ?? 'غير متوفر',
                    isEditable: false,
                  ),
                  ExpandableCard(
                    title: "رقم الهاتف",
                    content: userData?['phoneNumber'] ?? 'غير متوفر',
                    isEditable: true,
                    controller: _phoneController,
                    onSave: (value) => updateUserData('phoneNumber', value),
                  ),
                  ExpandableCard(
                    title: "البريد الالكتروني",
                    content: userData?['email'] ?? 'غير متوفر',
                    isEditable: true,
                    controller: _emailController,
                    onSave: (value) => updateUserData('email', value),
                  ),
                  ExpandableCard(
                    title: "كلمة المرور",
                    content: "******",
                    isEditable: true,
                    controller: _passwordController,
                    onSave: (value) => updateUserData('password', value),
                  ),
                ],
              ),
            ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final String name;
  final String? imagePath;

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
              backgroundColor: const Color.fromRGBO(180, 179, 179, 1),
              backgroundImage: isAssetImage
                  ? AssetImage(imagePath!) as ImageProvider
                  : const AssetImage('assets/default-avatar.png')
                      as ImageProvider,
              child: !isAssetImage
                  ? const Icon(Icons.person,
                      size: 40, color: Color.fromARGB(255, 97, 97, 97))
                  : null,
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
  final bool isEditable;
  final TextEditingController? controller;
  final Function(String)? onSave;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.content,
    this.isEditable = false,
    this.controller,
    this.onSave,
  });

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  void _showEditDialog() {
    if (!widget.isEditable ||
        widget.controller == null ||
        widget.onSave == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل ${widget.title}'),
          content: TextField(
            controller: widget.controller,
            decoration:
                InputDecoration(hintText: 'أدخل ${widget.title} الجديد'),
          ),
          actions: [
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('حفظ'),
              onPressed: () {
                widget.onSave!(widget.controller!.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                  if (widget.isEditable)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: _showEditDialog,
                    ),
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
