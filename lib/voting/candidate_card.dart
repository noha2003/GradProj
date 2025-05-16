import 'package:flutter/material.dart';

class CandidateCard extends StatelessWidget {
  final String name;
  final String number;
  final VoidCallback onTap;

  const CandidateCard({
    super.key,
    required this.onTap,
    required this.name,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          maximumSize: const Size(311, 103),
          padding: const EdgeInsets.all(0),
          backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
          foregroundColor: Colors.black,
          side: const BorderSide(color: Color(0xFF7A0000), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "اسم المرشح: $name",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF7A0000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 60,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF7A0000),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
