import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/ADMIN/screens/login.dart';
import 'package:uuid/uuid.dart';

import '../services/auth_service.dart';
import 'candidacy_requests_screen.dart';
import 'list_details_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final Uuid _uuid = const Uuid();

  Future<void> updateListStatus(String listId, String newStatus) async {
    try {
      final listRef =
          FirebaseFirestore.instance.collection('lists_requests').doc(listId);

      DocumentSnapshot doc = await listRef.get();
      if (!doc.exists) {
        _showMessage('القائمة غير موجودة', success: false);
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      String? userId = data['userId'];
      String listName = data['listName'] ?? 'القائمة';

      if (userId == null || userId.isEmpty) {
        _showMessage('خطأ: معرّف المستخدم غير موجود في بيانات القائمة',
            success: false);
        return;
      }

      String? uniqueCode = data['listCode'];
      if (newStatus == 'approved') {
        if (uniqueCode == null) {
          uniqueCode = _uuid.v4().substring(0, 8);
          await listRef.update({
            'status': newStatus,
            'listCode': uniqueCode,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          _showMessage('تمت الموافقة وتوليد الكود: $uniqueCode', success: true);
        } else {
          await listRef.update({
            'status': newStatus,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          _showMessage('تمت الموافقة بنجاح', success: true);
        }

        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': userId,
          'title': 'تمت الموافقة على القائمة',
          'message': 'رمز قائمتك "$listName" هو: $uniqueCode',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
        _showMessage('تم إنشاء إشعار للمستخدم بنجاح', success: true);
      } else {
        await listRef.update({
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        _showMessage('تم الرفض بنجاح', success: true);

        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': userId,
          'title': 'تم رفض القائمة',
          'message':
              'تم رفض قائمتك "$listName". يرجى التواصل مع الإدارة لمزيد من التفاصيل.',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
        _showMessage('تم إنشاء إشعار رفض للمستخدم بنجاح', success: true);
      }
    } catch (e) {
      _showMessage('حدث خطأ أثناء تحديث الحالة أو إنشاء الإشعار: $e',
          success: false);
    }
  }

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

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'إدارة الطلبات',
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
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'طلبات إنشاء القوائم'),
                  Tab(text: 'طلبات الترشح'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
              ),
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: TabBarView(
                children: [
                  // Lists Requests Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('lists_requests')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('حدث خطأ أثناء جلب البيانات'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('لا توجد قوائم متاحة'));
                      }

                      final lists = snapshot.data!.docs;

                      return ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: lists.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 8,
                        ),
                        itemBuilder: (context, index) {
                          final list = lists[index];
                          final data = list.data() as Map<String, dynamic>;
                          final listName = data['listName'] ?? 'بدون اسم';
                          final status = data['status'] ?? 'غير محدد';
                          final listCode = data['listCode'] ?? 'غير متوفر';

                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            title: Text(
                              listName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('الحالة: $status'),
                                Text('الكود: $listCode'),
                              ],
                            ),
                            trailing: status == 'approved'
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : status == 'rejected'
                                    ? const Icon(Icons.cancel,
                                        color: Colors.red)
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await updateListStatus(
                                                  list.id, 'approved');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF7A0000),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                            ),
                                            child: const Text('موافقة',
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          const SizedBox(width: 8),
                                          OutlinedButton(
                                            onPressed: () async {
                                              await updateListStatus(
                                                  list.id, 'rejected');
                                            },
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.red,
                                              side: const BorderSide(
                                                  color: Colors.red),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                            ),
                                            child: const Text('رفض',
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                        ],
                                      ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ListDetailsScreen(listId: list.id),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  // Candidacy Requests Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('forms')
                        .snapshots(),
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
                            child: Text('لا توجد طلبات ترشح متاحة'));
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
                          final nationalId =
                              data['الرقم الوطني'] ?? 'بدون رقم وطني';
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
                                Text('الحالة: $status'),
                                Text(
                                    'المحافظة: ${data['المحافظة'] ?? 'غير محدد'}'),
                              ],
                            ),
                            trailing: status == 'approved'
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : status == 'rejected'
                                    ? const Icon(Icons.cancel,
                                        color: Colors.red)
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
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
                                              side: const BorderSide(
                                                  color: Colors.red),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                            ),
                                            child: const Text('رفض',
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                        ],
                                      ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CandidacyRequestsScreen(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
