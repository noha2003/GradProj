import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/create%20list/create2.dart';
import 'package:gradproj/home.dart';

class CreateList extends StatelessWidget {
  const CreateList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Home(
      child: FormScreen(),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<Widget> memberFields = [];
  List<GlobalKey<FormFieldState>> keys = [];
  Map<String, PlatformFile?> uploadedFiles = {};

  @override
  void initState() {
    super.initState();
    addInitialMembers(); // Add 3 fixed members initially
  }

  void addInitialMembers() {
    setState(() {
      for (int i = 0; i < 3; i++) {
        final key = GlobalKey<FormFieldState>();
        keys.add(key);
        memberFields.add(
          Row(
            key: key,
            children: [
              Expanded(
                child: _buildTextField(
                    'الرقم الوطني', TextInputType.number, false),
              ),
              const SizedBox(
                width: 8,
                height: 5,
              ),
              Expanded(
                child: _buildTextField(
                    'الاسم بالهوية الشخصية', TextInputType.text, true),
              ),
            ],
          ),
        );
      }
    });
  }

  void addMemberField() {
    setState(() {
      final key = GlobalKey<FormFieldState>();
      keys.add(key);
      memberFields.add(
        Row(
          key: key,
          children: [
            Expanded(
              child:
                  _buildTextField('الرقم الوطني', TextInputType.number, false),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildTextField(
                  'الاسم بالهوية الشخصية', TextInputType.text, true),
            ),
            const SizedBox(
              width: 8,
              height: 7,
            ),
            IconButton(
              padding: const EdgeInsets.all(4),
              icon: const Icon(Icons.remove_circle,
                  size: 18, color: Color.fromRGBO(122, 0, 0, 1)),
              onPressed: () => removeMemberField(key),
            ),
          ],
        ),
      );
    });
  }

  void removeMemberField(GlobalKey<FormFieldState> key) {
    setState(() {
      final index = keys.indexOf(key);
      if (index != -1) {
        keys.removeAt(index);
        memberFields.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SectionTitle(title: 'بيانات القائمة'),
            const SizedBox(height: 8),
            _buildTextField('المحافظة', TextInputType.text, true),
            _buildTextField(
                'الدائرة الانتخابية للقائمة', TextInputType.text, false),
            _buildTextField(
                'اسم القائمة الانتخابية', TextInputType.text, false),
            _buildTextField('عدد المترشحين', TextInputType.number, false),
            _buildTextField('عنوان مقر القائمة', TextInputType.text, false),
            const SizedBox(height: 16),
            const SectionTitle(title: 'بيانات مفوض القائمة وعنوانه'),
            const SizedBox(height: 16),
            _buildTextField('الرقم الوطني', TextInputType.number, true),
            _buildTextField('الاسم الاول', TextInputType.text, true),
            _buildTextField('اسم الاب', TextInputType.text, true),
            _buildTextField('اسم العائلة', TextInputType.text, true),
            _buildFileUploadField('صورة عن الهوية الشخصية'),
            _buildTextField('رقم الهاتف', TextInputType.number, true),
            _buildTextField('البريد الالكتروني', TextInputType.text, true),
            _buildFileUploadField('التوقيع'),
            const SizedBox(height: 16),
            const SectionTitle(title: 'الوثائق المطلوبة'),
            const SizedBox(height: 16),
            _buildFileUploadField('صورة عن رمز القائمة المحلية'),
            _buildFileUploadField(
                'ايصال مالي يثبص بأن القائمة المحلية قد دفعت للخزينة(500) دينار تأميناً لإللتزام باألحكام المتعلقة بالدعاية االنتخابية'),
            _buildFileUploadField(
                'تعهد خطي بأن القائمة المحلية ستقوم بتقديم (افصاح مالي عن موارد تمويل الحملة االنتخابية وأوجه انفاقها وفتح حساب بنكي لغايات بيان أوجه الصرف على الحملة االنتخابية وتعين محاسب قانوني) خلال (سبعة أيام) من تبليغ قرار الهيئة القبول لطلب الترشح.'),
            const SizedBox(height: 16),
            const SectionTitle(
                title: 'اعضاء القائمة حسب تسلسل الاولوية المتفق عليها'),
            const SizedBox(height: 16),
            Column(
              children: memberFields,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: addMemberField,
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة عضو'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuccessCreate()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(122, 0, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Text(
                        'ارسال',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextInputType inputType, bool isReadOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.end, // محاذاة التسمية للنهاية (اليمين)
        children: [
          TextField(
            textAlign: TextAlign.right, // محاذاة النص داخل الـ TextField
            keyboardType: inputType,
            readOnly: isReadOnly, // إذا كان الحقل للعرض فقط، لا يمكن تعديله
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
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
        ],
      ),
    );
  }

  Widget _buildFileUploadField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
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
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(122, 0, 0, 1),
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

// class CustomLabeledTextField extends StatelessWidget {
//   final String label;
//   final List<String>? autofillHints;
//   const CustomLabeledTextField(
//       {super.key, required this.label, this.autofillHints});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 12, color: Colors.black),
//           ),
//           const SizedBox(height: 6),
//           TextField(
//             autofillHints: autofillHints,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: const Color(0xFFD9D9D9),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: const BorderSide(
//                   color: Color.fromRGBO(122, 0, 0, 1),
//                   width: 1,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 borderSide: const BorderSide(
//                   color: Color.fromRGBO(122, 0, 0, 1),
//                   width: 1.5,
//                 ),
//               ),
//             ),
//             textAlign: TextAlign.right,
//           ),
//         ],
//       ),
//     );
//   }
// }
