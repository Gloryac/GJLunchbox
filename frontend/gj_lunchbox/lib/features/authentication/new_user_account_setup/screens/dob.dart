import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/image_strings.dart';
import 'package:dj_lunchbox/utils/constants/sizes.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import '../widgets/backButton.dart';
import '../widgets/nextButton.dart';
import '../widgets/skipButton.dart';

class DobPage extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const DobPage({
    super.key,
    required this.currentPage,
    required this.totalPages,
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
                      TextStrings.accountSetUpTextTitle3,
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
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                TextStrings.accountSetUpCalendarText,
                                style: AppTextTheme.textStyles.labelSmall?.copyWith(
                                  color: AppColors.lightGreen),
                              ),
                            ),
                            Image(
                              width: AppSizes.iconXs,
                              height: AppSizes.iconXs,
                              image: AssetImage(ImageString.calender),
                            ),
                          ],
                        ),
                      ),
                    ),



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
