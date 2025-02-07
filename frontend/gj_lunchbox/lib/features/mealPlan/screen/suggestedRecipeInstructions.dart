import 'package:flutter/material.dart';

import '../../recipe/model/recipe.dart';
import '../widget/suggestedRecipes/nutritionInfo.dart';


// ... other imports (your model and widgets)

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: recipe.imageUrl != null
                  ? Image.network(
                recipe.imageUrl!,
                fit: BoxFit.cover,
              )
                  : const Center(
                  child: Icon(Icons.image,
                      size: 50, color: Colors.white)), // Placeholder
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // Implement favorite functionality
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  NutritionInfo(recipe: recipe),
                  const SizedBox(height: 24),

                  // Ingredients Section (No Plus/Minus)
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  if (recipe.ingredients.isNotEmpty) // Check if ingredients list is not empty
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = recipe.ingredients[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '• ${ingredient['name'] ?? ''}', // Handle missing 'name'
                                ),
                              ),
                              if (ingredient.containsKey('quantity')) ...[
                                const SizedBox(width: 8),
                                Text(
                                    '${ingredient['quantity'] ?? ''} ${ingredient.containsKey('unit') ? ingredient['unit'] ?? '' : ''}'), // Handle missing quantity or unit
                              ],
                            ],
                          ),
                        );
                      },
                    )
                  else
                    const Text("No ingredients listed."), // Display message if no ingredients


                  const SizedBox(height: 24),

                  // Instructions Section
                  Text(
                    'Instructions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  if (recipe.instructions.isNotEmpty) // Check if instructions list is not empty
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.instructions.length,
                      itemBuilder: (context, index) {
                        final instruction = recipe.instructions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('${index + 1}. $instruction'),
                        );
                      },
                    )
                  else
                    const Text("No instructions listed."), // Display message if no instructions
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}