import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/image_strings.dart';
import 'package:dj_lunchbox/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/constants/text_style.dart';



class PreparingPlanPage extends StatelessWidget {
  const PreparingPlanPage({
    super.key,
    // required this.image,
    // required this.title,
    // required this.subTitle,
  });

  // final String image, title, subTitle;

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
                SizedBox(height: 150),
                Image(
                  width: 223,
                  height: 223,
                  image: AssetImage(ImageString.page6),
                ),
                Text(
                  TextStrings.accountSetUpTextTitle6,
                  style: AppTextTheme.textStyles.headlineMedium,
                  textAlign: TextAlign.center,),
                SizedBox(height: AppSizes.spaceBtnItems),
                Text(
                  TextStrings.accountSetUpTextBody2,
                  style: AppTextTheme.textStyles.bodyMedium?.copyWith(
                    color: AppColors.lightGreen
                  ),
                  textAlign: TextAlign.center,)
              ],

          ),
          ),

        ],
      ),
    );
  }
}