import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart'; // Import your text styles


//import '../model/suggestedRecipe.dart';
import '../../recipe/model/recipe.dart';
import '../widget/suggestedRecipes/recipeCard.dart'; // Import your Recipe model

class SuggestedRecipesPage extends StatelessWidget {
  final List<Recipe> recipes;
  final String mealType;

  const SuggestedRecipesPage({super.key, required this.recipes, required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recipes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Here are some suggestions based on your ingredients',
                  style: AppTextTheme.textStyles.bodyLarge, // Use your text style
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.sentiment_satisfied_alt,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(recipe: recipes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

