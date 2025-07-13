import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/text_style.dart';
import '../../../recipe/model/recipe.dart';
import '../../../recipe/screen/recipeInstructions.dart';


class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback? onFavoriteToggled;

  const RecipeCard({super.key, required this.recipe,this.onFavoriteToggled,});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isFavorite = false;
  bool isLoading = true;
  late final RecipeFavoriteService _favoriteService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _favoriteService = RecipeFavoriteService();
    _loadFavoriteStatus();
  }
  Future<void> _loadFavoriteStatus() async {
    setState(() {
      isLoading = true; // Set loading to true while fetching status
    });
    final status = await _favoriteService.checkIfFavorite(widget.recipe.id);
    if (mounted) { // Check if the widget is still mounted before setState
      setState(() {
        isFavorite = status;
        isLoading = false; // Set loading to false once status is known
      });
    }
  }
  Future<void> _handleFavoriteToggle() async {
    // Temporarily disable the button while the operation is in progress
    setState(() {
      isLoading = true;
    });

    await _favoriteService.toggleFavorite(
      context: context,
      recipe: widget.recipe,
      onFavoriteStatusChanged: (isFav) {
        if (mounted) {
          setState(() {
            isFavorite = isFav;
            isLoading = false; // Set loading to false after status update
          });
          // Call the callback if it's provided
          widget.onFavoriteToggled?.call(); // <--- CALL THE CALLBACK HERE
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: widget.recipe),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.recipe.imageUrl ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.recipe.name,
                          style: AppTextTheme.textStyles.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.recipe.calories} Kcal',
                              style: AppTextTheme.textStyles.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.schedule,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.recipe.cookTime} Min',
                              style: AppTextTheme.textStyles.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Favorite Button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 24,
                ),
                onPressed: isLoading ? null : _handleFavoriteToggle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}