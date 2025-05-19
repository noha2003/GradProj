import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../header.dart';
import 'election2.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ElectionCodeScreen(),
  ));
}

class ElectionCodeScreen extends StatefulWidget {
  const ElectionCodeScreen({super.key});

  @override
  _ElectionCodeScreenState createState() => _ElectionCodeScreenState();
}

class _ElectionCodeScreenState extends State<ElectionCodeScreen> {
  final TextEditingController _listCodeController = TextEditingController();
  String? _errorMessage;

  // Fetches the national ID of the logged-in user from the users collection
  Future<String?> _getUserNationalId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'المستخدم غير مسجل الدخول';
        });
        print('Error: No user logged in');
        return null;
      }

      String uid = user.uid;
      print('Fetching user document for UID: $uid');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = 'بيانات المستخدم غير موجودة في قاعدة البيانات';
        });
        print('Error: User document does not exist for UID: $uid');
        return null;
      }

      var userDoc = querySnapshot.docs.first;
      print('User document data: ${userDoc.data()}');
      String? nationalId = userDoc['nationalId']?.toString();
      if (nationalId == null || nationalId.isEmpty) {
        setState(() {
          _errorMessage = 'رقم الهوية الوطنية غير متوفر في بيانات المستخدم';
        });
        print('Error: nationalId field missing or empty');
        return null;
      }

      print('Retrieved nationalId: $nationalId');
      return nationalId;
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ أثناء جلب بيانات المستخدم: $e';
      });
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Validates the list code and checks if the user's nationalId is in the members array
  Future<bool> _validateInput(String listCode, String nationalId) async {
    try {
      print('Validating listCode: $listCode, nationalId: $nationalId');
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('lists_requests')
          .where('listCode', isEqualTo: listCode)
          .get();

      if (query.docs.isEmpty) {
        setState(() {
          _errorMessage = 'رمز القائمة غير موجود';
        });
        print('Error: No list found with listCode: $listCode');
        return false;
      }

      for (var doc in query.docs) {
        String status = doc['status'];
        print('List status for doc ${doc.id}: $status');
        if (status != 'approved') {
          setState(() {
            _errorMessage = 'حالة القائمة غير معتمدة';
          });
          print('Error: List is not approved for doc ${doc.id}');
          continue;
        }

        List<dynamic> members = doc['members'] ?? [];
        print('Members for doc ${doc.id}: $members');
        bool idMatch = members
            .any((member) => member['nationalId'].toString() == nationalId);
        if (idMatch) {
          setState(() {
            _errorMessage = null;
          });
          print('Validation successful for doc ${doc.id}');
          return true;
        } else {
          setState(() {
            _errorMessage = 'رقم الهوية الوطنية غير موجود في القائمة';
          });
          print(
              'Error: nationalId $nationalId not found in members for doc ${doc.id}');
        }
      }

      return false;
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ أثناء التحقق: $e';
      });
      print('Error during validation: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'للتقدم للانتخابات، يجب أن تكون ضمن قائمة انتخابية، وتشترط إدخال الرمز الخاص بالقائمة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A0000),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Icon(
              Icons.fact_check,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'ادخل رمز القائمة الانتخابية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7A0000),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _listCodeController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF7A0000)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF7A0000)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF7A0000)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFF7A0000),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    side: const BorderSide(color: Color(0xFF7A0000)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'رجوع',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7A0000),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A0000),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    String listCode = _listCodeController.text.trim();

                    setState(() {
                      _errorMessage = null;
                    });

                    if (listCode.isEmpty) {
                      setState(() {
                        _errorMessage = 'الرجاء إدخال رمز القائمة';
                      });
                      print('Error: List code is empty');
                      return;
                    }

                    String? nationalId = await _getUserNationalId();
                    if (nationalId == null) {
                      return;
                    }

                    bool isValid = await _validateInput(listCode, nationalId);
                    if (isValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationForm(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listCodeController.dispose();
    super.dispose();
  }
}
