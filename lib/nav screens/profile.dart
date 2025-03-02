import 'package:flutter/material.dart';
import 'package:gradproj/home2.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Home_without(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UserInfo(name: "محمد احمد عبد الهادي"),
              ],
            ),
            ExpandableCard(title: "الرقم الوطني", content: "123456789"),
            ExpandableCard(title: "تاريخ الميلاد", content: "01-01-2002"),
            ExpandableCard(title: "الجنس", content: "ذكر"),
            ExpandableCard(
                title: "الدائرة الانتخابية", content: "الدائرة الأولى"),
            ExpandableCard(
                title: "حالة المستخدم (مرشح / غير مرشح)", content: "مرشح"),
            ExpandableCard(title: "رقم الهاتف", content: "123456789"),
            ExpandableCard(
                title: "البريد الالكتروني", content: "example@example.com"),
            ExpandableCard(
              title: "كلمة المرور",
              content: "******",
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final String name;
  const UserInfo({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
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
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color.fromRGBO(180, 179, 179, 1),
              child: Icon(Icons.person,
                  size: 40, color: Color.fromARGB(255, 97, 97, 97)),
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
