import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../header.dart';
import 'election3.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, PlatformFile?> uploadedFiles = {};
  bool isLoading = true;

  // Colors
  static const Color headerColor = Color(0xFF7A0000);
  static const Color backgroundColor = Color(0xFFD9D9D9);
  static const Color readOnlyBackgroundColor =
      Color.fromARGB(255, 201, 201, 201);

  final List<Map<String, dynamic>> fields = [
    {'label': 'الرقم الوطني', 'type': TextInputType.number},
    {'label': 'المؤهل العلمي', 'type': TextInputType.text},
    {'label': 'المسمى الوظيفي', 'type': TextInputType.text},
    {'label': 'مكان العمل', 'type': TextInputType.text},
    {'label': 'عمر المرشح', 'type': TextInputType.number},
    {'label': 'المحافظة', 'type': TextInputType.text},
    {'label': 'الدائرة الانتخابية للمرشح', 'type': TextInputType.text},
  ];

  final List<String> fileFields = [
    'صورة شخصية',
    'صورة عن الهوية الشخصية',
    'شهادة جنسية أردنية',
    'شهادة عدم محكومية',
    'التوقيع',
  ];

  final List<String> readOnlyFields = [
    'الرقم الوطني',
    'المحافظة',
    'عمر المرشح',
    'الدائرة الانتخابية للمرشح', // Added to read-only fields
  ];

  @override
  void initState() {
    super.initState();
    for (var field in fields) {
      _controllers[field['label']] = TextEditingController();
    }
    _fetchUserData();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        setState(() {
          _controllers['الرقم الوطني']?.text =
              userDoc['nationalId']?.toString() ?? '';
          _controllers['المحافظة']?.text = userDoc['gover'] ?? '';
          _controllers['عمر المرشح']?.text = userDoc['age']?.toString() ?? '';
          _controllers['الدائرة الانتخابية للمرشح']?.text =
              userDoc['electoralDistrict']?.toString() ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('بيانات المستخدم غير موجودة')),
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء جلب البيانات: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Prepare form data
      final data = {
        for (var entry in _controllers.entries) entry.key: entry.value.text,
        'files':
            uploadedFiles.map((label, file) => MapEntry(label, file?.name)),
        'userId': userId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save to forms collection
      await FirebaseFirestore.instance.collection('forms').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تقديم الطلب بنجاح', textAlign: TextAlign.center),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تقديم الطلب: $e',
              textAlign: TextAlign.center),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _allFilesUploaded() {
    for (var key in fileFields) {
      if (uploadedFiles[key] == null) return false;
    }
    return true;
  }

  Widget _buildTextField(String label, TextInputType inputType) {
    final bool isReadOnly = readOnlyFields.contains(label);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          textAlign: TextAlign.right,
          controller: _controllers[label],
          keyboardType: inputType,
          readOnly: isReadOnly,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال $label';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: isReadOnly ? readOnlyBackgroundColor : backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: headerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: headerColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: headerColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: headerColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFileUploadField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              setState(() {
                uploadedFiles[label] = result.files.first;
              });
            }
          },
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: headerColor, width: 1.5),
            ),
            child: Center(
              child: Text(
                uploadedFiles[label]?.name ?? 'اضغط لرفع الملف',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const Header(),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ...fields
                        .map((f) => _buildTextField(f['label'], f['type'])),
                    ...fileFields.map(_buildFileUploadField),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: headerColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _allFilesUploaded()) {
                          _submitForm();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'يرجى تعبئة جميع الحقول ورفع جميع الملفات'),
                            ),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        child: Text(
                          'ارسال',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
