import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/device/device_utility.dart';

class AccountSetUpNextButton extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const AccountSetUpNextButton({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (currentPage + 1) / totalPages;

    return Positioned(
      right: 0,
      left: 0,
      bottom: DeviceUtils.getBottomNavigationBarHeight(),
      child: Stack(
        alignment: Alignment.center,
        children: [

          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: AppColors.gray,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
          ),
          // Elevated Button
          ElevatedButton(
            onPressed: () {
              // Define your button action here
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              backgroundColor: AppColors.green,
              padding: const EdgeInsets.all(16),
            ),
            child: Icon(
              Iconsax.arrow_right,
              size: 24,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
