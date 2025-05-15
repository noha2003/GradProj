import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradproj/create%20list/create2.dart';

import 'firestore_service.dart';
import 'form_fields.dart';
import 'section_title.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<Widget> memberFields = [];
  List<GlobalKey<FormFieldState>> keys = [];
  Map<String, PlatformFile?> uploadedFiles = {};

  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController futhernameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = true;
  bool isFormComplete = false;
  bool areFilesUploaded = false;
  String? _selectedConstituency;
  String? _selectedGovernorate;
  final List<String> _governorates = [
    'عمان',
    'الزرقاء',
    'إربد',
    'الكرك',
    'معان',
    'المفرق',
    'الطفيلة',
    'العقبة',
    'جرش',
    'عجلون',
    'مادبا',
    'البلقاء',
  ];
  final List<String> _constituencies = [
    'العاصمة / الدائرة الاولى',
    'العاصمة / الدائرة الثانية',
    'العاصمة / الدائرة الثالثة',
    'الزرقاء',
    'اربد / الدائرة الاولى',
    'اربد / الدائرة الثانية',
    'الكرك',
    'المفرق',
    'البلقاء',
    'جرش',
    'عجلون',
    'مادبا',
    'العقبة',
    'الطفيلة',
    'معان',
    'بدو الجنوب',
    'بدو الشمال',
    'بدو الوسط',
  ];
  List<TextEditingController> nationalIdControllers = [];
  List<TextEditingController> nameControllers = [];
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController candidatesCountController =
      TextEditingController();
  final TextEditingController listAddressController = TextEditingController();

  void handleFileUpload(String label, PlatformFile file) {
    setState(() {
      uploadedFiles[label] = file;
      print("File uploaded for $label: ${file.name}");
    });
    checkFormCompletion();
  }

  void checkFormCompletion() {
    setState(() {
      bool allFieldsFilled = nationalIdController.text.isNotEmpty &&
          firstnameController.text.isNotEmpty &&
          futhernameController.text.isNotEmpty &&
          lastnameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          _selectedGovernorate != null &&
          _selectedConstituency != null;
      bool allFilesUploaded = uploadedFiles.length == 5;
      isFormComplete = allFieldsFilled;
      areFilesUploaded = allFilesUploaded;
      print(
          "Form complete: $isFormComplete, Files uploaded: $areFilesUploaded");
    });
  }

  bool isDelegateInMembers() {
    String delegateNationalId = nationalIdController.text.trim();
    for (var controller in nationalIdControllers) {
      if (controller.text.trim() == delegateNationalId) {
        return true;
      }
    }
    return false;
  }

  void _showAwesomeDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
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
  void initState() {
    super.initState();
    addInitialMembers();
    _fetchUserData();
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
          nationalIdController.text = userDoc['nationalId'].toString();
          firstnameController.text = userDoc['firstname'] ?? '';
          futhernameController.text = userDoc['futhername'] ?? '';
          lastnameController.text = userDoc['lastname'] ?? '';
          phoneController.text = userDoc['phoneNumber'] ?? '';
          emailController.text = userDoc['email'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("No user data found for uid: $uid");
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTextFieldWithController(TextEditingController controller,
      TextInputType inputType, bool isReadOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        keyboardType: inputType,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          hintText: isReadOnly
              ? ''
              : (inputType == TextInputType.number
                  ? 'أدخل الرقم الوطني'
                  : 'أدخل الاسم'),
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF7A0000)),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF7A0000)),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF7A0000), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onChanged: (value) {
          if (!isReadOnly && inputType == TextInputType.number) {
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _createMemberField(int index) {
    final key = GlobalKey<FormFieldState>();
    final nationalIdController = TextEditingController();
    final nameController = TextEditingController();

    nationalIdController.addListener(() async {
      final nationalIdText = nationalIdController.text.trim();
      if (nationalIdText.isNotEmpty) {
        try {
          final nationalId = int.tryParse(nationalIdText);
          if (nationalId == null) {
            setState(() {
              nameController.text = '';
            });
            return;
          }
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('nationalId', isEqualTo: nationalId)
              .limit(1)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            var userData =
                querySnapshot.docs.first.data() as Map<String, dynamic>;
            String fullName = userData['name'] ?? '';
            setState(() {
              nameController.text = fullName;
            });
          } else {
            setState(() {
              nameController.text = '';
            });
          }
        } catch (e) {
          print("Error fetching user data: $e");
          setState(() {
            nameController.text = '';
          });
        }
      } else {
        setState(() {
          nameController.text = '';
        });
      }
    });

    nationalIdControllers.add(nationalIdController);
    nameControllers.add(nameController);
    keys.add(key);

    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'الرقم الوطني',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      _buildTextFieldWithController(
                          nationalIdController, TextInputType.number, false),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'الاسم بالهوية الشخصية',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      _buildTextFieldWithController(
                          nameController, TextInputType.text, true),
                    ],
                  ),
                ),
              ],
            ),
            if (index >= 3)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.remove_circle,
                    size: 18,
                    color: Color.fromRGBO(122, 0, 0, 1),
                  ),
                  onPressed: () => removeMemberField(key),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void addInitialMembers() {
    setState(() {
      for (int i = 0; i < 3; i++) {
        memberFields.add(_createMemberField(i));
      }
    });
  }

  void addMemberField() {
    setState(() {
      memberFields.add(_createMemberField(memberFields.length));
    });
  }

  void removeMemberField(GlobalKey<FormFieldState> key) {
    setState(() {
      final index = keys.indexOf(key);
      if (index != -1 && index >= 3) {
        keys.removeAt(index);
        memberFields.removeAt(index);
        nationalIdControllers[index].dispose();
        nameControllers[index].dispose();
        nationalIdControllers.removeAt(index);
        nameControllers.removeAt(index);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in nationalIdControllers) {
      controller.dispose();
    }
    for (var controller in nameControllers) {
      controller.dispose();
    }
    nationalIdController.dispose();
    firstnameController.dispose();
    futhernameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    listNameController.dispose();
    candidatesCountController.dispose();
    listAddressController.dispose();
    super.dispose();
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
            buildGovernorateDropdown(_selectedGovernorate, _governorates,
                (String? newValue) {
              setState(() {
                _selectedGovernorate = newValue;
              });
              checkFormCompletion();
            }),
            buildConstituencyDropdown(_selectedConstituency, _constituencies,
                (String? newValue) {
              setState(() {
                _selectedConstituency = newValue;
              });
              checkFormCompletion();
            }),
            const Text(
              'اسم القائمة الانتخابية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldWithController(
                listNameController, TextInputType.text, false),
            const Text(
              'عدد المترشحين',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldWithController(
                candidatesCountController, TextInputType.number, false),
            const Text(
              'عنوان مقر القائمة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldWithController(
                listAddressController, TextInputType.text, false),
            const SizedBox(height: 16),
            const SectionTitle(title: 'بيانات مفوض القائمة وعنوانه'),
            const SizedBox(height: 16),
            const Text(
              'الرقم الوطني',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldF(nationalIdController, true, TextInputType.number),
            const Text(
              'الاسم الاول',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldF(firstnameController, true, TextInputType.text),
            const Text(
              'اسم الاب',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldF(futhernameController, true, TextInputType.text),
            const Text(
              'اسم العائلة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldF(lastnameController, true, TextInputType.text),
            buildFileUploadField(
                'صورة عن الهوية الشخصية', uploadedFiles, handleFileUpload),
            const Text(
              'رقم الهاتف',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldF(phoneController, true, TextInputType.phone),
            const Text(
              'البريد الالكتروني',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            buildTextFieldF(emailController, true, TextInputType.emailAddress),
            buildFileUploadField('التوقيع', uploadedFiles, handleFileUpload),
            const SizedBox(height: 16),
            const SectionTitle(title: 'الوثائق المطلوبة'),
            const SizedBox(height: 16),
            buildFileUploadField(
                'صورة عن رمز القائمة المحلية', uploadedFiles, handleFileUpload),
            buildFileUploadField(
                'ايصال مالي يثبت بأن القائمة المحلية قد دفعت للخزينة(500) دينار تأميناً لإللتزام باألحكام المتعلقة بالدعاية االنتخابية',
                uploadedFiles,
                handleFileUpload),
            buildFileUploadField(
                'تعهد خطي بأن القائمة المحلية ستقوم بتقديم (افصاح مالي عن موارد تمويل الحملة االنتخابية وأوجه انفاقها وفتح حساب بنكي لغايات بيان أوجه الصرف على الحملة االنتخابية وتعين محاسب قانوني) خلال (سبعة أيام) من تبليغ قرار الهيئة القبول لطلب الترشح.',
                uploadedFiles,
                handleFileUpload),
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
                    onPressed: () async {
                      if (isDelegateInMembers()) {
                        _showAwesomeDialog(
                            'خطأ', 'المفوض لا يمكن أن يكون عضوًا في القائمة');
                        return;
                      }
                      if (isFormComplete && areFilesUploaded) {
                        try {
                          await saveListRequest(
                            governorate: _selectedGovernorate,
                            constituency: _selectedConstituency,
                            listName: listNameController.text,
                            candidatesCount:
                                int.tryParse(candidatesCountController.text) ??
                                    0,
                            listAddress: listAddressController.text,
                            delegate: {
                              'nationalId':
                                  int.tryParse(nationalIdController.text) ?? 0,
                              'firstname': firstnameController.text,
                              'fatherName': futhernameController.text,
                              'lastname': lastnameController.text,
                              'phoneNumber': phoneController.text,
                              'email': emailController.text,
                            },
                            members: nationalIdControllers
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              return {
                                'nationalId': int.tryParse(
                                        nationalIdControllers[index].text) ??
                                    0,
                                'name': nameControllers[index].text,
                              };
                            }).toList(),
                            uploadedFiles: uploadedFiles,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SuccessCreate()),
                          );
                          _showMessage('تم الإرسال بنجاح', success: true);
                        } catch (e) {
                          _showAwesomeDialog('خطأ',
                              'حدث خطأ أثناء الإرسال. يرجى المحاولة مرة أخرى.');
                        }
                      } else {
                        if (!isFormComplete) {
                          _showMessage('يرجى تعبئة جميع الحقول المطلوبة');
                        } else if (!areFilesUploaded) {
                          _showMessage('يرجى رفع جميع الملفات المطلوبة');
                        }
                      }
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
}
