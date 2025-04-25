import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class CandidacyRequestsScreen extends StatelessWidget {
  const CandidacyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'طلبات الترشح',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF7A0000),
        foregroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 10,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => AuthService.signOut(context),
          tooltip: 'تسجيل الخروج',
        ),
      ),
      body: const Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Text(
            'لا توجد طلبات ترشح متاحة حاليًا',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
