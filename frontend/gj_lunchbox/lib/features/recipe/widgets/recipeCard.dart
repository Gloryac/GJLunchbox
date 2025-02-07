import 'package:dj_lunchbox/features/recipe/screen/recipeInstructions.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';

import '../model/recipe.dart';
import 'nutrition_info.dart';

class RecipeCard extends StatefulWidget { // Use StatefulWidget for favorite functionality
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isFavorite = false; // Track favorite state

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2, // Add elevation for a subtle lift
      shape: RoundedRectangleBorder( // Rounded corners for the card
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell( // Make the card tappable
        onTap: () {
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context)=>RecipeDetailScreen(recipe: widget.recipe,)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack( // Use a Stack to overlay the favorite button
              children: [
                // Image or Placeholder
                widget.recipe.imageUrl == null
                    ? Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.restaurant,
                        size: 50, color: Colors.grey),
                  ),
                )
                    : ClipRRect( // Clip image to card's rounded corners
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    widget.recipe.imageUrl!,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity, // Make image fill card width
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error,
                              size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),

                // Favorite Button (Positioned in the corner)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                        // Update your data model or backend here
                      });
                    },
                  ),
                ),
              ],
            ),

            // Recipe Text Content
            Padding(
              padding: const EdgeInsets.all(12.0), // Increased padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.recipe.name,
                      style: AppTextTheme.textStyles.labelMedium), // Larger font size
                  const SizedBox(height: 4), // Spacing between title and nutrition info
                  NutritionInfo(recipe: widget.recipe),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}