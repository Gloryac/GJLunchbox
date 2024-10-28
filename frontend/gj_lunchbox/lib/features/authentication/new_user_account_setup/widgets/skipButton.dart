import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';  // Assuming this contains AppColors for colors
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';

class AccountSetUpSkip extends StatelessWidget {
  const AccountSetUpSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: DeviceUtils.getAppBarHeight()-30,
      right: AppSizes.defaultSpace,
      child: ElevatedButton(
        onPressed: () {
          // Define your skip action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Skip',
          style: TextStyle(
            color: AppColors.lightGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
