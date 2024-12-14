import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import 'onboardingNextButton.dart';
import 'onboarding_controller.dart';
import 'onboarding_dot_navigation.dart';
import 'onboarding_page.dart';
import 'onboarding_skip.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController ());

    return Scaffold(
      body: Stack(
        children: [
          ///Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnboardingPage(
                image: ImageString.slide1,
                title: TextStrings.onBoardingTextTitle1,
                subTitle: TextStrings.onBoardingTextSubTitle1,
              ),
              OnboardingPage(
                image: ImageString.slide2,
                title: TextStrings.onBoardingTextTitle2,
                subTitle: TextStrings.onBoardingTextSubTitle2,
              ),
              OnboardingPage(
                image: ImageString.slide3,
                title: TextStrings.onBoardingTextTitle3,
                subTitle: TextStrings.onBoardingTextSubTitle3,
              ),
            ],
          ),

          /// Skip Button
          OnboardingSkip(),

          ///Dot Navigation SmoothPageIndicator
          OnboardingDotNavigation(),

          ///Circular Button
          OnboardingNextButton()
        ],
      ),
    );
  }
}

