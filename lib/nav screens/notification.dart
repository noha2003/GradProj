import 'package:flutter/material.dart';
import 'package:gradproj/home.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Home(
        child: Icon(
          Icons.notifications,
          size: 300,
          color: Color.fromARGB(124, 4, 0, 0),
        ),
      ),
    );
  }
}