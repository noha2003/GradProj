import 'package:flutter/material.dart';
import 'package:gradproj/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

//fghjjj
///dfjgdl
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Cairo',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}//dddddd
