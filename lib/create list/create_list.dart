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
            children: const [
              Expanded(
                child: CustomLabeledTextField(label: 'الرقم الوطني'),
              ),
              SizedBox(
                width: 8,
                height: 5,
              ),
              Expanded(
                child: CustomLabeledTextField(label: 'الاسم بالهوية الشخصية'),
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
            const Expanded(
              child: CustomLabeledTextField(label: 'الرقم الوطني'),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: CustomLabeledTextField(label: 'الاسم بالهوية الشخصية'),
            ),
            const SizedBox(
              width: 8,
              height: 7,
            ),
            IconButton(
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
            const CustomLabeledTextField(label: 'المحافظة'),
            const CustomLabeledTextField(label: 'الدائرة الانتخابية للقائمة'),
            const CustomLabeledTextField(label: 'اسم القائمة الانتخابية'),
            const CustomLabeledTextField(label: 'عدد المترشحين'),
            const CustomLabeledTextField(label: 'عنوان مقر القائمة'),
            const SizedBox(height: 16),
            const SectionTitle(title: 'بيانات مفوض القائمة وعنوانه'),
            const SizedBox(height: 8),
            const CustomLabeledTextField(
                label: 'الرقم الوطني', autofillHints: ['fffffffffffff']),
            const CustomLabeledTextField(
                label: 'الاسم الأول', autofillHints: ['fffffffffffff']),
            const CustomLabeledTextField(
                label: 'اسم الأب', autofillHints: ['fffffffffffff']),
            const CustomLabeledTextField(
                label: 'اسم العائلة', autofillHints: ['fffffffffffff']),
            const SizedBox(height: 16),
            const Text(
              'صورة عن الهوية الشخصية',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const DottedBorderContainer(),
            const CustomLabeledTextField(
                label: 'رقم الهاتف', autofillHints: ['fffffffffffff']),
            const CustomLabeledTextField(
                label: 'البريد الالكتروني', autofillHints: ['fffffffffffff']),
            const Text(
              'التوقيع',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const DottedBorderContainer(),
            const SizedBox(height: 16),
            const SectionTitle(title: 'الوثائق المطلوبة'),
            const SizedBox(height: 16),
            const Text(
              'صورة عن رمز القائمة المحلية',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            const DottedBorderContainer(),
           const  SizedBox(height: 8),
           const  Text(
              'ايصال مالي يثبص بأن القائمة المحلية قد دفعت للخزينة(500) دينار تأميناً لإللتزام باألحكام المتعلقة بالدعاية االنتخابية',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.right,
            ),
           const  SizedBox(height: 8),
           const  DottedBorderContainer(),
            const SizedBox(height: 8),
            const Text(
              'تعهد خطي بأن القائمة المحلية ستقوم بتقديم (افصاح مالي عن موارد تمويل الحملة االنتخابية وأوجه انفاقها وفتح حساب بنكي لغايات بيان أوجه الصرف على الحملة االنتخابية وتعين محاسب قانوني) خلال (سبعة أيام) من تبليغ قرار الهيئة القبول لطلب الترشح.',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.right,
            ),
           const  SizedBox(height: 8),
            const DottedBorderContainer(),
            const SizedBox(height: 16),
            const SectionTitle(
                title: 'اعضاء القائمة حسب تسلسل الاولوية المتفق عليها'),
           const  SizedBox(height: 16),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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

class CustomLabeledTextField extends StatelessWidget {
  final String label;
  final List<String>? autofillHints;
  const CustomLabeledTextField(
      {super.key, required this.label, this.autofillHints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 6),
          TextField(
            autofillHints: autofillHints,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFD9D9D9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(122, 0, 0, 1),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(122, 0, 0, 1),
                  width: 1.5,
                ),
              ),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(122, 0, 0, 1),
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.upload_file,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }
}