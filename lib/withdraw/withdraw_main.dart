import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/withdraw/withdraw2.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _electoralDistrictController =
      TextEditingController();

  String? nationalId;
  String? electoralDistrict;
  String? name;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          nationalId = data['nationalId']?.toString() ?? 'غير متوفر';
          electoralDistrict = data['electoralDistrict'] ?? 'غير متوفر';
          name = data['name'] ?? 'غير متوفر';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        _showMessage("لم يتم العثور على بياناتك.");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage("حدث خطأ أثناء جلب البيانات: $e");
    }
  }

  Future<void> withdrawCandidate() async {
    if (_electoralDistrictController.text.trim().isEmpty ||
        _reasonController.text.trim().isEmpty) {
      _showMessage("يرجى تعبئة جميع الحقول قبل تأكيد الانسحاب!");
      return;
    }

    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        _showMessage("يجب تسجيل الدخول أولًا!");
        return;
      }

      DocumentSnapshot candidateDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (candidateDoc.exists) {
        Map<String, dynamic> candidateData =
            candidateDoc.data() as Map<String, dynamic>;

        if (candidateData['status'] == 'مرشح') {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'status': 'غير مرشح',
            'withdraw_reason': _reasonController.text.trim(),
          });

          await FirebaseFirestore.instance
              .collection('withdrawn candidates')
              .doc(uid)
              .set({
            'name': name,
            'nationalId': nationalId,
            'electoralDistrict': electoralDistrict,
            'withdraw_reason': _reasonController.text.trim(),
            'withdraw_date': FieldValue.serverTimestamp(), // وقت الانسحاب
          });

          _showMessage("تم الانسحاب بنجاح!", success: true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SuccessWithdraw()),
          );
        } else {
          _showMessage("لا يمكن إكمال عملية الانسحاب لأنك لست مرشحًا حاليًا!");
        }
      } else {
        _showMessage("أنت لست مرشحًا، لا يمكنك الانسحاب!");
      }
    } catch (e) {
      _showMessage("حدث خطأ أثناء التحقق: $e");
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Home_without(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildReadOnlyField("الرقم الوطني", nationalId),
                    const SizedBox(height: 16),
                    _buildReadOnlyField(
                        "الدائرة الانتخابية", electoralDistrict),
                    const SizedBox(height: 16),
                    _buildEditableField("رقم القائمة الانتخابية",
                        _electoralDistrictController, "أدخل رقم القائمة هنا"),
                    const SizedBox(height: 16),
                    _buildEditableField(
                        "سبب الانسحاب", _reasonController, "أدخل سبب الانسحاب",
                        maxLines: 4),
                    const SizedBox(height: 16),
                    const Text(
                      'عند الانسحاب، لن تتمكن من العودة للترشح في هذه الدورة',
                      style: TextStyle(
                        color: Color.fromRGBO(122, 0, 0, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 16),
                    _buildButtons(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.right,
          decoration: _buildInputDecorationF(),
          controller: TextEditingController(text: value ?? 'غير متوفر'),
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.right,
          decoration: _buildInputDecoration(),
          controller: controller,
          maxLines: maxLines,
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration([String? hintText]) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide:
            const BorderSide(color: Color.fromRGBO(122, 0, 0, 1), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            const BorderSide(color: Color.fromRGBO(122, 0, 0, 1), width: 1.5),
      ),
    );
  }

  InputDecoration _buildInputDecorationF([String? hintText]) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide:
            const BorderSide(color: Color.fromRGBO(122, 0, 0, 1), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:
            const BorderSide(color: Color.fromRGBO(122, 0, 0, 1), width: 1.5),
      ),
      fillColor: const Color.fromARGB(255, 201, 201, 201), // لون السكني
      filled: true,
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD9D9D9),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(
                  color: Color.fromRGBO(122, 0, 0, 1), width: 2.0),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('رجوع',
                style: TextStyle(
                    color: Color.fromRGBO(122, 0, 0, 1), fontSize: 20)),
          ),
        ),
        ElevatedButton(
          onPressed: withdrawCandidate,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(122, 0, 0, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('تأكيد',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
      ],
    );
  }
}
