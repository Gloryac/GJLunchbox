import 'package:flutter/material.dart';
import '../model/recipe.dart';
import '../services/recipe_service.dart';

class RecipeList extends StatelessWidget {
  final String selectedCategory;
  final String searchQuery;
  final RecipeService recipeService;

  const RecipeList({
    Key? key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.recipeService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
      stream: recipeService.getRecipeByCategory(selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
              child: Text('No recipes found for this category.'));
        }

        final recipes = snapshot.data!
            .where((recipe) =>
            recipe.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final recipe = recipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text(recipe.category),
              );
            },
            childCount: recipes.length,
          ),
        );
      },
    );
  }
}
