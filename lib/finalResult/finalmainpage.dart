import 'package:flutter/material.dart';
import 'package:gradproj/back_button.dart';
import 'package:gradproj/election_district.dart';
import 'package:gradproj/home2.dart';
import 'package:gradproj/voting/custom_button.dart';

class FinalMainPage extends StatelessWidget {
  const FinalMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Home_without(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 115),
              child: CustomButton(
                  icon: Icons.bar_chart_outlined,
                  text: "النتائج الاولية الحالية 2028",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionDistrictsScreen(
                            screenType: ElectionScreenType.initialResults),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 66),
            CustomButton(
                icon: Icons.bar_chart_outlined,
                text: "النتائج النهائية للسنوات السابقة",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ElectionDistrictsScreen(
                          screenType: ElectionScreenType.finalResults),
                    ),
                  );
                }),
            const SizedBox(height: 124),
            const CustomBackButton()
          ],
        ),
      ),
    );
  }
}
