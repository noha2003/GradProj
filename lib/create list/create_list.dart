import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final List<String> _constituencies = [
    'العاصمة / الدائرة الاولى	',
    'العاصمة / الدائرة الثانية',
    'العاصمة / الدائرة الثالثة	',
    'الزرقاء',
    ' اربد / الدائرة الاولى',
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
    'بدو الجنوب', 'بدو الشمال', 'بدو الوسط',
    // أضف المزيد من الدوائر حسب الحاجة
  ];
  String? _selectedGovernorate; // لتخزين المحافظة المختارة
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
  List<TextEditingController> nationalIdControllers = [];
  List<TextEditingController> nameControllers = [];
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController candidatesCountController =
      TextEditingController();
  final TextEditingController listAddressController = TextEditingController();

  Future<void> saveListRequest() async {
    try {
      // جمع بيانات القائمة
      final listData = {
        'governorate': _selectedGovernorate,
        'constituency': _selectedConstituency,
        'listName': listNameController.text,
        'candidatesCount': int.tryParse(candidatesCountController.text) ?? 0,
        'listAddress': listAddressController.text,

        // بيانات مفوض القائمة
        'delegate': {
          'nationalId': int.tryParse(nationalIdController.text) ?? 0,
          'firstname': firstnameController.text,
          'fatherName': futhernameController.text,
          'lastname': lastnameController.text,
          'phoneNumber': phoneController.text,
          'email': emailController.text,
        },

        // الأرقام الوطنية للأعضاء
        'members': nationalIdControllers.map((controller) {
          return {
            'nationalId': int.tryParse(controller.text) ?? 0,
            'name':
                nameControllers[nationalIdControllers.indexOf(controller)].text,
          };
        }).toList(),

        // الملفات المرفوعة
        'uploadedFiles':
            uploadedFiles.map((label, file) => MapEntry(label, file?.name)),

        // معلومات إضافية
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pinned',
      };

      // إنشاء مستند جديد في collection "lists requests"
      await FirebaseFirestore.instance
          .collection('lists_requests')
          .add(listData);

      print("List request saved successfully!");
    } catch (e) {
      print("Error saving list request: $e");
      _showMessage('حدث خطأ أثناء حفظ الطلب', success: false);
      throw e;
    }
  }

  Widget _buildGovernorateDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'المحافظة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Container(
            height: 57.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7A0000)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              value: _selectedGovernorate,
              hint: const Text(
                'اختر المحافظة',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
              items: _governorates.map((String governorate) {
                return DropdownMenuItem<String>(
                  value: governorate,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      governorate,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGovernorate = newValue;
                });
                checkFormCompletion();
              },
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF7A0000),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              dropdownColor: const Color.fromARGB(255, 225, 223, 223),
              alignment: AlignmentDirectional.centerEnd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstituencyDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'الدائرة الانتخابية للقائمة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Container(
            height: 57.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7A0000)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              value: _selectedConstituency,
              hint: const Text(
                'اختر الدائرة الانتخابية',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
              items: _constituencies.map((String constituency) {
                return DropdownMenuItem<String>(
                  value: constituency,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      constituency,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConstituency = newValue;
                });
                checkFormCompletion();
              },
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF7A0000),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              dropdownColor: const Color.fromARGB(255, 225, 223, 223),
              alignment: AlignmentDirectional.centerEnd,
            ),
          ),
        ],
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
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          nationalIdController.text = userDoc['nationalId'].toString();
          firstnameController.text = userDoc['firstname'];
          futhernameController.text = userDoc['futhername'];
          lastnameController.text = userDoc['lastname'];
          phoneController.text = userDoc['phoneNumber'];
          emailController.text = userDoc['email'];
          isLoading = false; // تم تحميل البيانات
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
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
    });
  }

  void handleFileUpload(String label, PlatformFile file) {
    setState(() {
      uploadedFiles[label] = file;
    });
    checkFormCompletion();
  }

  void addInitialMembers() {
    setState(() {
      for (int i = 0; i < 3; i++) {
        final key = GlobalKey<FormFieldState>();
        keys.add(key);
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
                String fullName = '${userData['name']}';
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
        memberFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              key: key,
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
                        'الاسم بالهويةالشخصية',
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
          ),
        );
      }
    });
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

  void addMemberField() {
    setState(() {
      final key = GlobalKey<FormFieldState>();
      keys.add(key);
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
              // استخراج بيانات المستخدم
              var userData =
                  querySnapshot.docs.first.data() as Map<String, dynamic>;
              String fullName = '${userData['name']}';
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
      memberFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            key: key,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'الرقم الوطني',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      height: 20,
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    _buildTextFieldWithController(
                        nameController, TextInputType.text, true),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: const EdgeInsets.all(4),
                icon: const Icon(
                  Icons.remove_circle,
                  size: 18,
                  color: Color.fromRGBO(122, 0, 0, 1),
                ),
                onPressed: () => removeMemberField(key),
              ),
            ],
          ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SectionTitle(title: 'بيانات القائمة'),
            const SizedBox(height: 8),
            _buildGovernorateDropdown(),
            _buildConstituencyDropdown(),
            const Text(
              'اسم القائمة الانتخابية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldWithController(
                listNameController, TextInputType.text, false),
            const Text(
              'عدد المترشحين',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldWithController(
                candidatesCountController, TextInputType.number, false),
            const Text(
              'عنوان مقر القائمة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldWithController(
                listAddressController, TextInputType.text, false),
            const SizedBox(height: 16),
            const SectionTitle(title: 'بيانات مفوض القائمة وعنوانه'),
            const SizedBox(height: 16),
            const Text(
              'الرقم الوطني',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldF(nationalIdController, true, TextInputType.number),
            const Text(
              'الاسم الاول',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldF(firstnameController, true, TextInputType.text),
            const Text(
              'اسم الاب',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldF(futhernameController, true, TextInputType.text),
            const Text(
              'اسم العائلة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldF(lastnameController, true, TextInputType.text),
            _buildFileUploadField('صورة عن الهوية الشخصية'),
            const Text(
              'رقم الهاتف',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldF(phoneController, true, TextInputType.phone),
            const Text(
              'البريد الالكتروني',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            _buildTextFieldF(emailController, true, TextInputType.emailAddress),
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
                    onPressed: () async {
                      if (isFormComplete && areFilesUploaded) {
                        try {
                          // حفظ البيانات في Firestore
                          await saveListRequest();

                          // الانتقال إلى شاشة النجاح وعرض رسالة
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SuccessCreate()),
                          );
                          _showMessage('تم الإرسال بنجاح', success: true);
                        } catch (e) {
                          _showMessage('حدث خطأ أثناء الإرسال', success: false);
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

  Widget _buildTextFieldF(TextEditingController controller, bool isReadOnly,
      TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: inputType,
            readOnly: isReadOnly,
            decoration: InputDecoration(
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
              fillColor: const Color.fromARGB(255, 201, 201, 201), // لون السكني
              filled: true,
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
              height: 100,
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
