import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/home2.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return const Home_without(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications,
                size: 300,
                color: Color.fromARGB(124, 4, 0, 0),
              ),
              Text(
                'يرجى تسجيل الدخول لعرض الإشعارات',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: currentUserId)
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Home_without(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 300,
                      color: Colors.red,
                    ),
                    Text(
                      'حدث خطأ أثناء جلب الإشعارات\nتأكد من إعدادات Firestore',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cairo',
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Home_without(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 300,
                      color: Color.fromARGB(124, 4, 0, 0),
                    ),
                    Text(
                      'لا توجد إشعارات حاليًا\nتأكد من أن الإدمن وافق على قائمة',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cairo',
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return Home_without(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final data = notification.data() as Map<String, dynamic>;

                if (!data.containsKey('userId') || !data.containsKey('timestamp')) {
                  return const SizedBox.shrink();
                }

                final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
                final formattedTime = timestamp != null
                    ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp)
                    : 'غير متوفر';
                final isRead = data['isRead'] ?? false;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: isRead ? Colors.white : Colors.grey[200],
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      data['title'] ?? 'إشعار جديد',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                        color: const Color(0xFF7A0000),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          data['messagelist'] ?? 'لا يوجد محتوى',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'التاريخ: $formattedTime',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    leading: Icon(
                      isRead ? Icons.notifications : Icons.notifications_active,
                      color: const Color(0xFF7A0000),
                      size: 30,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await notification.reference.delete();
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
