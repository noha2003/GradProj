import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ListDetailsScreen extends StatelessWidget {
  final String listId;

  const ListDetailsScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل القائمة'),
        backgroundColor: const Color(0xFF7A0000),
        foregroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => AuthService.signOut(context),
          tooltip: 'تسجيل الخروج',
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('lists_requests')
              .doc(listId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('حدث خطأ أثناء جلب التفاصيل'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('القائمة غير موجودة'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final delegate = data['delegate'] as Map<String, dynamic>? ?? {};
            final members = (data['members'] as List<dynamic>?) ?? [];
            final uploadedFiles =
                (data['uploadedFiles'] as Map<String, dynamic>?) ?? {};

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSectionTitle('بيانات القائمة'),
                  _buildDetailItem(
                      'اسم القائمة', data['listName'] ?? 'غير متوفر'),
                  _buildDetailItem(
                      'المحافظة', data['governorate'] ?? 'غير متوفر'),
                  _buildDetailItem('الدائرة الانتخابية',
                      data['constituency'] ?? 'غير متوفر'),
                  _buildDetailItem('عدد المترشحين',
                      data['candidatesCount']?.toString() ?? 'غير متوفر'),
                  _buildDetailItem(
                      'عنوان القائمة', data['listAddress'] ?? 'غير متوفر'),
                  _buildDetailItem('الحالة', data['status'] ?? 'غير متوفر'),
                  _buildDetailItem('الكود', data['listCode'] ?? 'غير متوفر'),
                  const SizedBox(height: 16),
                  _buildSectionTitle('بيانات مفوض القائمة'),
                  _buildDetailItem('الرقم الوطني',
                      delegate['nationalId']?.toString() ?? 'غير متوفر'),
                  _buildDetailItem(
                      'الاسم الأول', delegate['firstname'] ?? 'غير متوفر'),
                  _buildDetailItem(
                      'اسم الأب', delegate['fatherName'] ?? 'غير متوفر'),
                  _buildDetailItem(
                      'اسم العائلة', delegate['lastname'] ?? 'غير متوفر'),
                  _buildDetailItem(
                      'رقم الهاتف', delegate['phoneNumber'] ?? 'غير متوفر'),
                  _buildDetailItem(
                      'البريد الإلكتروني', delegate['email'] ?? 'غير متوفر'),
                  const SizedBox(height: 16),
                  _buildSectionTitle('أعضاء القائمة'),
                  members.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('لا يوجد أعضاء'),
                        )
                      : Column(
                          children: members.asMap().entries.map((entry) {
                            final index = entry.key + 1;
                            final member = entry.value as Map<String, dynamic>;
                            return _buildDetailItem(
                              'عضو $index',
                              'الرقم الوطني: ${member['nationalId']}\nالاسم: ${member['name']}',
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('الملفات المرفوعة'),
                  uploadedFiles.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('لا توجد ملفات مرفوعة'),
                        )
                      : Column(
                          children: uploadedFiles.entries.map((entry) {
                            return _buildDetailItem(
                                entry.key, entry.value ?? 'غير متوفر');
                          }).toList(),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7A0000),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.end,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 16,
          ),
        ],
      ),
    );
  }
}
