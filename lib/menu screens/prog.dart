import 'package:flutter/material.dart';
import 'package:gradproj/home.dart';

class ProgScreen extends StatelessWidget {
  const ProgScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Home(
      child: Padding(
        padding:  EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               SizedBox(height: 10),
              Text(
                "ملتقى \"أنا أشارك\" الشبابي الأول",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromRGBO(122, 0, 0, 1),
                ),
              ),
              Text(
                "\nيهدف ملتقى \"أنا أشارك\" الشبابي الأوّل إلى دمج الشباب الأردني في الجامعات في الحوار والعمل العام، وذلك استجابة للتوجيهات الملكيّة ومخرجات لجنة تحديث المنظومة السياسيّة، والتي يتمحور جزءٌ منها حول ضرورة تفعيل دور الشباب ومشاركتهم في المجالات السياسية والاقتصادية والاجتماعية\n يسعى الملتقى إلى خلق مساحة حوارية بين الشباب على مستوى الجامعات، ومن ثم المحافظات، ومن ثم على مستوى الوطن، وذلك بهدف فتح باب الحوار للاستماع لأولوياتهم ضمن المشاركة السياسية، كما يرونها هم أنفسهم وكما يطرحونها. ومن خلال هذه المساحة، سيتم تعزيز وبناء قدرات المشاركين للوصول بهم إلى المقدرة على تطوير ورقة سياسات تعبّر عنهم أمام الوزارات والهيئات والمؤسسات المعنيّة\nغطي ملتقى \"أنا أشارك\" الشبابي الأول جملة من القضايا والأولويات الوطنية، أهمها العمل الحزبي، وسيادة القانون، والمشاركة السياسية للشباب والمرأة، والهوية الوطنية، وغيرها من القضايا، كلّها من وجهة النظر الشبابية. يهدف الملتقى إلى الخروج برؤى وتصورات وطنية تجاه مختلف هذه الأولويات، وذلك للوصول إلى وضع أطر وطنية موحدة تناقش وتطور وتنفذ من قبل مختلف الجهات ذات العلاقة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                ":الفترة الزمنية لأعمال الملتقى",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color:  Color.fromRGBO(122, 0, 0, 1),
                ),
              ),
              Text(
                " يبدأ استقبال طلبات التسجيل في شهرتموز - آب ٢٠٢٢ \nبدأ مرحلة التنفيذ/ اختيار المشاركين والدورات التدريبية في شهر آب - أيلول ٢٠٢٢ \nيعقد المنتدى الختامي في النصف الأول من شهر تشرين الأول ٢٠٢٢ ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                " \nالمعهد الانتخابي الأردني",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color:  Color.fromRGBO(122, 0, 0, 1),
                ),
              ),
              Text(
                "\nعملت الهيئة على انشاء المعهد الانتخابي الأردني في العام 2020 بموجب نظام التنظيم الإداري للهيئة المستقلة للانتخاب رقم (61) لسنة 2020 ويعتبر صرحاً اكاديمياً وتدريبياً متميزاً على المستوى المحلي والإقليمي، ويسعى الى تحقيق الأهداف التالية\n\n رفع كفاءة موظفي الهيئة وجميع العاملين في الانتخابات والمهتمين بها والشركاء المحليين والدوليين وتدريبهم وتأهيلهم وإعدادهم علمياً وعملياً لتمكينهم من القيام بمهامهم وتحمل مسؤولياتهم في مجال إدارة الانتخابات والعمليات الانتخابية\n\nالمساهمة في زيادة الوعي الانتخابي والعمل على ترسيخ وتعزيز مبادئ الأمانة والنزاهة والحياد والشفافية والممارسات الفضلى في الانتخابات",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "\n:ويقوم المعهد في سبيل تحقيق أهدافه بما يلي",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color:  Color.fromRGBO(122, 0, 0, 1),
                ),
              ),
              Text(
                "\n تقديم برامج ودورات تدريبية في مجال الانتخابات-\n\nتقديم الاستشارات في مجال عمل المعهد لاي جهة محلية أو عربية أو دولية\n\nاجراء البحوث والدراسات العملية بمجال عمل المعهد وتوثيقها ونشره",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                "\n\nوايماناً بذلك الدور فقد تم استحداث برنامج الدبلوم العالي في السياسات الانتخابية لإثراء المعرفة النظرية والمنهجية حول الانتخابات بالإضافة الى الممارسة العملية التي تعزز فهم السياسات الانتخابية وكذلك التعرف على الأنظمة الانتخابية وكيفية إدارتها",
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