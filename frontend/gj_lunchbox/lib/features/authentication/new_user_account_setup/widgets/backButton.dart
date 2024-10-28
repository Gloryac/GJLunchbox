import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
class AccountSetUpBack extends StatelessWidget {
  const AccountSetUpBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: DeviceUtils.getAppBarHeight() -20 ,
        left: AppSizes.defaultSpace,
        child: Icon(
          Icons.arrow_left,
          size: 24,
          color: AppColors.black,
        )
    );
  }
}