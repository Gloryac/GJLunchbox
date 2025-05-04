import 'package:dj_lunchbox/features/recipe/widgets/recipeCard.dart';
import 'package:flutter/material.dart';

import '../model/recipe.dart';
import '../services/recipe_service.dart';

class RecipeList extends StatelessWidget {
  final String selectedCategory;
  final String searchQuery;
  final RecipeService recipeService;

  const RecipeList({
    super.key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.recipeService,
  });

  @override
  Widget build(BuildContext context) {
    Stream<List<Recipe>> recipeStream;

    if (searchQuery.isNotEmpty) {
      recipeStream = recipeService.searchRecipes(searchQuery);
    } else {
      recipeStream = recipeService.getRecipeByCategory(selectedCategory);
    }

    return StreamBuilder<List<Recipe>>(
      stream: recipeStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text('Error loading recipes: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final recipes = snapshot.data ?? [];

        if (recipes.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No recipes found')),
          );
        }

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final recipe = recipes[index];
              return RecipeCard(recipe: recipe);
            },
            childCount: recipes.length,
          ),
        );
      },
    );
  }
}