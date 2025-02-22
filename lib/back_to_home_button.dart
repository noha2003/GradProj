import 'package:flutter/material.dart';
import 'package:gradproj/main_screen.dart';

class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
         Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const MainScreen();
                  },
                ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7A0000),
        foregroundColor: const Color.fromRGBO(217, 217, 217, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF7A0000)),
        ),
        elevation: 4,
        minimumSize: const Size(262, 44),
      ),
      child: const Text("انتقل الى الصفحة الرئيسية ",
          style: TextStyle(color: Colors.white, fontSize: 20 ,
          fontWeight: FontWeight.normal)),
    );
  }
}
