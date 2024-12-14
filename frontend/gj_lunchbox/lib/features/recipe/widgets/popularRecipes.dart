import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_style.dart';

class PopularRecipes extends StatelessWidget {
  const PopularRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildRecipeCard(
            imageAsset: ImageString.recipe1,
            title: TextStrings.popularRecipes1,
            calories: TextStrings.popularCal1,
            cookingTime: TextStrings.popularTime1,

          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _buildRecipeCard(
            imageAsset: ImageString.recipe2,
            title: TextStrings.popularRecipes2,
            calories: TextStrings.popularCal2,
            cookingTime: TextStrings.popularTime2,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard({
    required String imageAsset,
    required String title,
    required String calories,
    required String cookingTime,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            imageAsset,
            width: 168,
            height: 128,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16.0),
        Text(title, style: AppTextTheme.textStyles.labelMedium),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(calories, style: AppTextTheme.textStyles.labelSmall),
            const SizedBox(width: 8.0),
            Text(cookingTime, style: AppTextTheme.textStyles.labelSmall),
          ],
        ),
      ],
    );
  }
}