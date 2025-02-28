import 'package:flutter/material.dart';
//import 'package:gradproj/candidates.dart';

class ListsPage extends StatelessWidget {
  final String name;
  final String image;
  final String number;
  const ListsPage(
      {super.key,
      required this.onTap,
      required this.name,
      required this.image,
      required this.number});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(356, 126),
          padding: const EdgeInsets.symmetric(vertical: 21.0, horizontal: 18),
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          foregroundColor: Colors.black,
          side: const BorderSide(color: Color(0xFF7A0000), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onTap,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("اسم القائمة: $name",
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF7A0000))),
              Text("رقم القائمة: $number",
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF7A0000))),
            ]),
          ),
        ]),
      ),
    );
  }
}
