import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/image_strings.dart';
import 'package:dj_lunchbox/utils/constants/sizes.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import '../widgets/backButton.dart';
import '../widgets/nextButton.dart';
import '../widgets/skipButton.dart';

class GenderPage extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const GenderPage({
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
                      TextStrings.accountSetUpTextTitle1,
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
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligns the cards at the top
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spaces the cards evenly
                        children: [
                          // First Card
                          SizedBox(
                            width: 157, // Card width
                            height: 180, // Card height
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Image(
                                      width: 92,
                                      height: 92,
                                      image: AssetImage(ImageString.page21),
                                    ),
                                    Expanded(
                                      child: Text(
                                        TextStrings.accountSetUpTextPage21,
                                        style: AppTextTheme.textStyles.labelMedium?.copyWith(
                                          color: AppColors.lightGreen,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Second Card
                          SizedBox(
                            width: 157, // Card width
                            height: 180, // Card height
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Image(
                                      width: 92,
                                      height: 92,
                                      image: AssetImage(ImageString.page22),
                                    ),
                                    Expanded(
                                      child: Text(
                                        TextStrings.accountSetUpTextPage22,
                                        style: AppTextTheme.textStyles.labelMedium?.copyWith(
                                          color: AppColors.lightGreen,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
