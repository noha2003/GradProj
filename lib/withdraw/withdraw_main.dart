import 'package:flutter/material.dart';
import 'package:gradproj/home.dart';
import 'package:gradproj/withdraw/withdraw2.dart';

class WithdrawalScreen extends StatelessWidget {
  const WithdrawalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Home(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, bottom: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
             const Text(
                'الرقم الوطني ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              // الرقم الوطني
              TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1.5,
                    ),
                  ),
                ),

                controller: TextEditingController(
                    text: '20XXXXXXXX96'), // Autofill value
                readOnly: true, // Make it non-editable
              ),
              const SizedBox(height: 16.0),
              const Text(
                'الدائرة الانتخابية',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),

              // الدائرة الانتخابية
              TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  // labelText: 'الدائرة الانتخابية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1.5,
                    ),
                  ),
                ),
                controller: TextEditingController(
                    text: 'عمان الاولى'), // Autofill value
                readOnly: true, // Make it non-editable
              ),
              const SizedBox(height: 16.0),
             const  Text(
                'رقم القائمة الانتخابية',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),

              // رقم القائمة الانتخابية
              TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'أدخل رقم القائمة هنا',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1.5,
                    ),
                  ),
                ),
                controller: TextEditingController(text: ''),
              ),
              const SizedBox(height: 16),
             const  Text(
                'سبب الانسحاب',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              // سبب الانسحاب
              TextField(
                textAlign: TextAlign.right,
                maxLines: 4,
                decoration: InputDecoration(
                  //labelText: 'سبب الانسحاب',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(122, 0, 0, 1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // ملاحظة
             const Text(
                'عند الانسحاب، لن تتمكن من العودة للترشح في هذه الدورة',
                style: TextStyle(
                  color: Color.fromRGBO(122, 0, 0, 1),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16.0),

              // أزرار التأكيد والرجوع
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action for back button
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFD9D9D9), // لون الزر (فاتح)
                      foregroundColor: Colors.black, // لون النص
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side:const  BorderSide(
                            color: Color.fromRGBO(122, 0, 0, 1), width: 2.0),
                      ),
                    ),
                    child:const  Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'رجوع',
                        style: TextStyle(
                            color: Color.fromRGBO(122, 0, 0, 1), fontSize: 20),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuccessWithdraw()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(122, 0, 0, 1), // لون الزر (غامق)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'تأكيد',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}