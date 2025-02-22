import 'package:flutter/material.dart';

import 'package:gradproj/home.dart';

class LawsScreen extends StatelessWidget {
  const LawsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Home(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              const Text(
                "ينظم عمل الهيئة المستقلة للانتخاب عددٌ من التشريعات\nفكمؤسسة، تحمل الهيئة المستقلة للانتخاب صفة الدستورية، وذلك من خلال المادة (2/67) من الدستور الأردني\nكما وبحسب القانون، \"تلتزم الوزارات والدوائر الحكومية والمؤسسات الرسمية والعامّة بتقديم جميع أنواع الدعم والمساعدة التي تطلبها الهيئة لتمكينها من القيام بالمهام والمسؤوليات المناطة بها…\"\nفي خارج الموسم الانتخابي، تلتزم الهيئة بمهامها ودورها القانوني بـ \"توعية الناخبين بأهمية المشاركة في الحياة السياسية بما في ذلك العمليات الانتخابية\"\nوتالياً ما ينظم علاقات الهيئة من عقود، ابتداءً من الدستور ووصولاً للتقارير شديدة التفصيل",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
             const Text(
                "\n: الدستور الاردني\n",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(122, 0, 0, 1),
                ),
                textAlign: TextAlign.right,
              ),
              Image.asset(
                'assets/images/dstor.jpeg',
                height: 150,
                width: 150,
                alignment: Alignment.centerRight,
              ),
              const Text(
                "\n: القوانين",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromRGBO(122, 0, 0, 1),
                ),
                textAlign: TextAlign.right,
              ),
              const Text(
                "\nتعمل الهيئة المستقلة للانتخاب وفق قانونها رقم (11) لسنة 2012، والتعديلات التي أجريت عليه بموجب القانون المعدل رقم (46) لسنة 2015، حيث يحدد القانون التعريفات الأساسية لعمل الهيئة، ومسؤوليات الهيئة، وآليات تشكيل ومهام ومسؤوليات مجلس المفوضين والأمانة العامة، بالاضافة الى عدد من البنود الناظمة لعمل الهيئة\n",
                style:TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/qanonent.jpeg',
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/images/qanonhy2a.jpeg',
                        height: 150,
                        width: 150,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/27zab.jpeg',
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/images/circles.jpeg',
                        height: 150,
                        width: 150,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}