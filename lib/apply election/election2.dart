import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../header.dart';
import 'election3.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  Map<String, PlatformFile?> uploadedFiles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('الرقم الوطني', TextInputType.number),
                  _buildTextField('المؤهل العلمي', TextInputType.text),
                  _buildTextField('المسمى الوظيفي', TextInputType.text),
                  _buildTextField('مكان العمل', TextInputType.text),
                  _buildTextField('عمر المرشح', TextInputType.number),
                  _buildTextField('المحافظة', TextInputType.text),
                  _buildTextField(
                      'الدائرة الانتخابية للمرشح', TextInputType.text),
                  _buildTextField('نوع المقعد', TextInputType.text),
                  _buildFileUploadField('صورة شخصية'),
                  _buildFileUploadField('صورة عن الهوية الشخصية'),
                  _buildFileUploadField('شهادة جنسية أردنية'),
                  _buildFileUploadField('شهادة عدم محكومية'),
                  _buildFileUploadField('التوقيع'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      _submitForm();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuccessScreen()),
                      );
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      child: Text(
                        'إرسال',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF7A0000)),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF7A0000)),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF7A0000)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                setState(() {
                  uploadedFiles[label] = result.files.first;
                });
              }
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF7A0000)),
                borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }

  void _submitForm() {
    if (uploadedFiles.values.any((file) => file == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى رفع جميع الملفات المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال النموذج بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
