import 'package:flutter/material.dart';
import 'package:gradproj/home.dart';

import 'form_screen.dart';

class CreateList extends StatelessWidget {
  const CreateList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home(
      child: FormScreen(),
    );
  }
}
