import 'package:dj_lunchbox/features/recipe/screen/recipeInstructions.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/recipe.dart';
import 'nutrition_info.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: const EdgeInsets.all(8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailScreen(recipe: widget.recipe),
                ),
              );
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.45,
                minHeight: 180,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section - Fixed aspect ratio
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: widget.recipe.imageUrl != null &&
                              widget.recipe.imageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.recipe.imageUrl!,
                              fit: BoxFit.cover,
                              memCacheWidth: 300,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 40),
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.fastfood,
                                    size: 40, color: Colors.white),
                              ),
                            ),
                    ),
                  ),

                  // Content Section - Flexible with constraints
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      constraints: const BoxConstraints(
                        minHeight: 80, // Minimum space for text + nutrition
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Recipe Name - Flexible with max lines
                          Flexible(
                            child: Text(
                              widget.recipe.name,
                              style:
                                  AppTextTheme.textStyles.labelMedium?.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Nutrition Info - Fixed height container
                          SizedBox(
                            height: 36, // Reduced from 40
                            child: NutritionInfo(
                              recipe: widget.recipe,
                              isCompact: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
