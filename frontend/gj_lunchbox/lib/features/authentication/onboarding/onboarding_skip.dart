import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';

class OnboardingSkip extends StatelessWidget {
  const OnboardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: DeviceUtils.getAppBarHeight() -20 ,
        right: AppSizes.defaultSpace,
        child: const Text('Skip'));
  }
}