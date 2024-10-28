import 'package:dj_lunchbox/main.dart';
import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/image_strings.dart';
import 'package:dj_lunchbox/utils/constants/sizes.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import '../widgets/backButton.dart';
import '../widgets/heightPicker.dart';
import '../widgets/nextButton.dart';
import '../widgets/skipButton.dart';

class HeightPage extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int initialValue;
  final int minValue;
  final int maxValue;

  const HeightPage({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 100),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "$currentPage",
                              style:AppTextTheme.textStyles.labelSmall,
                            ),
                            TextSpan(
                              text: "/$totalPages",
                              style:AppTextTheme.textStyles.labelSmall?.copyWith(
                                  color: AppColors.lightGreen
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceBtnItems),
                    Text(
                      TextStrings.accountSetUpTextTitle4,
                      style: AppTextTheme.textStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceBtnItems),
                    Text(
                      TextStrings.accountSetUpTextBody1,
                      style: AppTextTheme.textStyles.bodyMedium?.copyWith(
                          color: AppColors.lightGreen
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceBtnSections),
                    HeightPicker(
                      initialValue: initialValue,
                      minValue: minValue,
                      maxValue: maxValue,),



                  ]
              )
          ),


          AccountSetUpNextButton(
            currentPage: currentPage,
            totalPages: totalPages,
          ),
          AccountSetUpSkip(),
          AccountSetUpBack(),
        ],
      ),
    );
  }
}
