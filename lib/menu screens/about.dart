import 'package:flutter/material.dart';

import 'package:gradproj/home.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Home(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 10),
              Text(
                ": نبذة عن الهيئة ",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(122, 0, 0, 1),
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10),
              Text(
                "\nتأسست الهيئة المستقلة للانتخاب عام 2012 كجهة مستقلة تعنى بإدارة العملية الانتخابية والإشراف عليها دون تدخل أو تأثير من أي جهة, وتعد الهيئة إحدى ثمرات الإصلاح السياسي في المملكة الأردنية الهاشمية بقيادة جلالة الملك عبدالله الثاني ابن الحسين، وتعبر عن استجابة المؤسسة الرسمية للمطالب الشعبية",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "\nتأسست الهيئة بهدف ضمان إجراء انتخابات نيابية تتوافق مع المعايير الدولية، وبما يكفل إعادة ثقة المواطن بالعملية الانتخابية ومخرجاتها، ومعالجة تراكمات الماضي السلبية والبناء على ما تم تحقيقه من إنجازات وخطواتٍ إصلاحية",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "\nباشرت الهيئة عملها في شهر أيار من العام 2012 وتمكنت خلال فترة قياسية من العمل على بناء هيكلها المؤسسي وتوفير ضمانات استدامته، والإعداد لإجراء انتخابات مجلس النواب الأردني السابع عشر التي جرت مطلع العام 2013 كأول انتخابات تديرها الهيئة بعد إنشائها",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "\nفي عام 2014، وبموجب التعديلات الدستورية، تم توسيع دور ومسؤوليّات الهيئة المستقلة للانتخاب، لتشمل إدارة الانتخابات البلدية وأي انتخاباتٍ عامة، إضافة إلى ما تكلفها به الحكومة من إدارة وإشراف على أية انتخاباتٍ أخرى، وبما يضمن أعلى مستويات الشفافية والنزاهة والحياد في إدارة العمليات الانتخابية المختلفة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "\nأشرفت الهيئة بعد ذلك على عدد من الانتخابات الفرعية، وانتخابات المجالس البلدية ومجلس أمانة عمان الكبرى والتي نفذتها الحكومة في شهر آب 2013",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              )
            ],
          ),
        ),
      ),
    );
  }
}
