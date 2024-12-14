import 'package:dj_lunchbox/features/recipe/widgets/categories.dart';
import 'package:dj_lunchbox/features/recipe/widgets/popularRecipes.dart';
import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/image_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';

import '../widgets/featuredRecipes.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(TextStrings.recipe),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(child: ListView(
          //   children: [
          //     FeaturedRecipe(
          //     imageAsset: ImageString.recipe1,
          //     title: TextStrings.featuredTitle1,
          //     author: TextStrings.featuredAuthor1,
          //     cookingTime: TextStrings.featuredTime1,
          //   ),FeaturedRecipe(
          //     imageAsset: ImageString.recipe2,
          //     title: TextStrings.featuredTitle2,
          //     author: TextStrings.featuredAuthor2,
          //     cookingTime: TextStrings.featuredTime2,
          //   ),
          //   ],
          // ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeaturedSection(),
                const SizedBox(height: 13.0),
                Text(TextStrings.category, style: AppTextTheme.textStyles.headlineSmall,),
                const SizedBox(height: 13.0),
                Categories(),
                const SizedBox(height: 13.0),
                Text(TextStrings.popularRecipes, style: AppTextTheme.textStyles.headlineSmall,),
                const SizedBox(height: 13.0),
                PopularRecipes(),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
