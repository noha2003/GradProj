import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/ADMIN/screens/login.dart';

import '../services/auth_service.dart';

class CandidacyRequestsScreen extends StatefulWidget {
  const CandidacyRequestsScreen({super.key});

  @override
  _CandidacyRequestsScreenState createState() =>
      _CandidacyRequestsScreenState();
}

class _CandidacyRequestsScreenState extends State<CandidacyRequestsScreen> {
  Future<void> updateFormStatus(String formId, String newStatus) async {
    try {
      final formRef =
          FirebaseFirestore.instance.collection('forms').doc(formId);

      DocumentSnapshot doc = await formRef.get();
      if (!doc.exists) {
        _showMessage('الطلب غير موجود', success: false);
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      String? userId = data['userId'];
      String nationalId = data['الرقم الوطني'] ?? 'طلب ترشح';

      if (userId == null || userId.isEmpty) {
        _showMessage('خطأ: معرّف المستخدم غير موجود في بيانات الطلب',
            success: false);
        return;
      }

      await formRef.update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      String notificationTitle;
      String notificationMessage;
      if (newStatus == 'approved') {
        notificationTitle = 'تمت الموافقة على طلب الترشح';
        notificationMessage =
            'تمت الموافقة على طلب ترشحك (الرقم الوطني: $nationalId).';
        _showMessage('تمت الموافقة بنجاح', success: true);
      } else {
        notificationTitle = 'تم رفض طلب الترشح';
        notificationMessage =
            'تم رفض طلب ترشحك (الرقم الوطني: $nationalId). يرجى التواصل مع الإدارة لمزيد من التفاصيل.';
        _showMessage('تم الرفض بنجاح', success: true);
      }

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'title': notificationTitle,
        'message': notificationMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      _showMessage('تم إنشاء إشعار للمستخدم بنجاح', success: true);
    } catch (e) {
      _showMessage('حدث خطأ أثناء تحديث الحالة أو إنشاء الإشعار: $e',
          success: false);
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showFormDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'تفاصيل طلب الترشح: ${data['الرقم الوطني'] ?? 'بدون رقم وطني'}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildSectionTitle('بيانات طلب الترشح'),
                _buildDetailItem(
                    'الرقم الوطني', data['الرقم الوطني'] ?? 'غير متوفر'),
                _buildDetailItem(
                    'المؤهل العلمي', data['المؤهل العلمي'] ?? 'غير متوفر'),
                _buildDetailItem(
                    'المسمى الوظيفي', data['المسمى الوظيفي'] ?? 'غير متوفر'),
                _buildDetailItem(
                    'مكان العمل', data['مكان العمل'] ?? 'غير متوفر'),
                _buildDetailItem('عمر المرشح',
                    data['عمر المرشح']?.toString() ?? 'غير متوفر'),
                _buildDetailItem('المحافظة', data['المحافظة'] ?? 'غير متوفر'),
                _buildDetailItem('الدائرة الانتخابية',
                    data['الدائرة الانتخابية للمرشح'] ?? 'غير متوفر'),
                _buildDetailItem(
                    'نوع المقعد', data['نوع المقعد'] ?? 'غير متوفر'),
                _buildDetailItem('الحالة', data['status'] ?? 'غير متوفر'),
                const SizedBox(height: 16),
                _buildSectionTitle('الملفات المرفوعة'),
                data['files'] == null || (data['files'] as Map).isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('لا توجد ملفات مرفوعة'),
                      )
                    : Column(
                        children: (data['files'] as Map<String, dynamic>)
                            .entries
                            .map((entry) {
                          return _buildDetailItem(
                              entry.key, entry.value ?? 'غير متوفر');
                        }).toList(),
                      ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق', style: TextStyle(fontSize: 16)),
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'غير مصرح لك بالوصول كإداري',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A0000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('العودة إلى تسجيل الدخول',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

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
            elevation: 0,
            centerTitle: false,
            titleSpacing: 10,
            leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => AuthService.signOut(context),
              tooltip: 'تسجيل الخروج',
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('forms').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('حدث خطأ أثناء جلب البيانات'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('لا توجد طلبات ترشح متاحة حاليًا',
                          style: TextStyle(fontSize: 18)));
                }

                final forms = snapshot.data!.docs;

                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: forms.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 8,
                  ),
                  itemBuilder: (context, index) {
                    final form = forms[index];
                    final data = form.data() as Map<String, dynamic>;
                    final nationalId = data['الرقم الوطني'] ?? 'بدون رقم وطني';
                    final status = data['status'] ?? 'غير محدد';

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Text(
                        'طلب ترشح: $nationalId',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('الحالة: $status',
                              style: const TextStyle(fontSize: 14)),
                          Text('المحافظة: ${data['المحافظة'] ?? 'غير محدد'}',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      trailing: status == 'approved'
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : status == 'rejected'
                              ? const Icon(Icons.cancel, color: Colors.red)
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await updateFormStatus(
                                            form.id, 'approved');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF7A0000),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                      child: const Text('موافقة',
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: () async {
                                        await updateFormStatus(
                                            form.id, 'rejected');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side:
                                            const BorderSide(color: Colors.red),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                      child: const Text('رفض',
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                  ],
                                ),
                      onTap: () {
                        _showFormDetails(data);
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
