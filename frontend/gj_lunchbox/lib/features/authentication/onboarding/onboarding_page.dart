import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_style.dart';
import '../../../utils/helpers/helperfunctions.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            Image(
              width: HelperFunctions.screenWidth() * 0.8,
              height: HelperFunctions.screenHeight() * 0.6,
              image: AssetImage(image),
            ),
            Text(
              title,
              style: AppTextTheme.textStyles.headlineLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: AppSizes.spaceBtnItems),
            Text(
              subTitle,
              style: AppTextTheme.textStyles.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ],
        ) //Column
    );
  }
}