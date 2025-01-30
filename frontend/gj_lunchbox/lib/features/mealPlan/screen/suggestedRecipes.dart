import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';

import '../model/suggestedRecipe.dart';
import '../widget/suggestedRecipes/recipeCard.dart';

class RecipesPage extends StatefulWidget {
  final List<String> ingredients;
  final String mealType;

  const RecipesPage({
    super.key,
    required this.ingredients,
    required this.mealType,
  });

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      // TODO: Replace with your actual API call
      // Simulated API response
      await Future.delayed(const Duration(seconds: 1));
      final List<Recipe> fetchedRecipes = [
        Recipe(
          id: '1',
          name: 'Eggs, toasted bread and bacon',
          imageUrl: 'assets/images/breakfast.jpg', // Replace with your image
          calories: 120,
          cookingTime: 20,
          ingredients: ['eggs', 'bread', 'bacon'],
        ),
        // Add more recipes as needed
      ];

      setState(() {
        recipes = fetchedRecipes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

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
                  style: AppTextTheme.textStyles.bodyLarge,
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(
                    recipe: recipes[index],
                    onTap: () {
                      // TODO: Navigate to recipe details page
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}