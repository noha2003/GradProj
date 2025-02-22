import 'package:flutter/material.dart';

import 'package:gradproj/home.dart';
import 'package:gradproj/menu%20screens/faq2.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Home(
      child: FAQContent(),
    );
  }
}

class FAQContent extends StatefulWidget {
  const FAQContent({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _FAQContentState createState() => _FAQContentState();
}

class _FAQContentState extends State<FAQContent> {
  final List<bool> _isOpen = List.generate(7, (_) => false);

  final List<Map<String, String>> faqData = [
    {
      'question':
          'هل يحق للمرشح الذي وجد خطأ في البيانات الخاصة به بعد إرسالها أن يعدلها؟',
      'answer':
          'لا يمكن تعديل البيانات بعد الإرسال. يجب التأكد من صحة البيانات قبل الإرسال.'
    },
    {
      'question':
          'هل يجوز استخدام اسم القائمة ورمزها في أكثر من دائرة انتخابية؟',
      'answer': 'لا، اسم القائمة ورمزها مخصص لدائرة انتخابية واحدة فقط.'
    },
    {
      'question': 'هل يمكنني التصويت لأكثر من مرشح في نفس القائمة الانتخابية؟',
      'answer': 'نعم, يمكن التصويت لاكثر من مرشح واحد في كل قائمة انتخابية.'
    },
    {
      'question': 'كيف يمكنني التأكد من أن صوتي تم إرساله؟',
      'answer':
          'يمكنك التأكد من إرسال صوتك عن طريق رسالة تأكيد تظهر بعد الإرسال.'
    },
    {
      'question': 'كيف يمكنني معرفة الدائرة الانتخابية الخاصة بي؟',
      'answer':
          'يمكنك معرفة دائرتك الانتخابية من خلال بياناتك في الملف الشخصي الخاص بك.'
    },
    {
      'question': 'ما هو الحد الأدنى لعدد مرشحي القائمة؟',
      'answer': 'الحد الأدنى لعدد مرشحي القائمة هو ثلاثة مرشحين.'
    },
    {
      'question': 'ما هو الحد الأقصى لعدد مرشحي القائمة؟',
      'answer':
          'الحد الأقصى لعدد مرشحي القائمة يعتمد على الدائرة الانتخابية ويتفاوت حسب القانون.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'الأسئلة الشائعة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(122, 0, 0, 1),
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ...faqData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final faq = entry.value;

                  return Column(
                    children: [
                      FAQItem(
                        isOpen: _isOpen[index],
                        question: faq['question']!,
                        answer: faq['answer']!,
                        onToggle: (expanded) {
                          setState(() {
                            _isOpen[index] = expanded;

                            // **Scroll to the bottom if necessary**
                            if (expanded) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Scrollable.ensureVisible(
                                  context,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              });
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                _buildTextInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
       const Text(
          'إذا كان لديك أي سؤال آخر الرجاء إدخاله',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'اكتب سؤالك هنا...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color.fromRGBO(122, 0, 0, 1),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color.fromRGBO(122, 0, 0, 1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Color.fromRGBO(122, 0, 0, 1),
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(122, 0, 0, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SuccessScreen()),
              );
            },
            child: const Text(
              'إرسال',
              style:TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}

class FAQItem extends StatefulWidget {
  final bool isOpen;
  final String question;
  final String answer;
  final ValueChanged<bool> onToggle;

  const FAQItem({
    super.key,
    required this.isOpen,
    required this.question,
    required this.answer,
    required this.onToggle,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 217, 217, 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(122, 0, 0, 1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 123, 123, 123).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              widget.onToggle(!widget.isOpen);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Icon(
                  widget.isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          if (widget.isOpen)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.answer,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }
}