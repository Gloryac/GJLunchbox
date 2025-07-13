import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../multi_date_picker_modal.dart';
import '../model/recipe.dart';
import '../widgets/nutrition_info.dart';

class RecipeFavoriteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // IMPORTANT: Ensure this collection name matches your Firestore structure!
  // It should be 'userFavorites' if you're using the single document per user approach.
  static const String _favoritesCollectionName = 'Favorites'; // Or 'Favorites' if that's what you truly use

  /// Checks if a given recipe is favorited by the current user.
  /// Returns true if favorite, false otherwise.
  /// Returns false if no user is logged in or an error occurs.
  Future<bool> checkIfFavorite(String recipeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }

      final userFavoritesDocRef = _firestore
          .collection(_favoritesCollectionName)
          .doc(user.uid);

      final docSnapshot = await userFavoritesDocRef.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        if (data.containsKey('favoriteRecipeIds')) {
          final List<String> favoriteRecipeIds = List<String>.from(data['favoriteRecipeIds'] ?? []);
          return favoriteRecipeIds.contains(recipeId);
        }
      }
      return false; // Document or 'favoriteRecipeIds' field not found, so not a favorite
    } catch (e) {
      print('Error checking favorite status: $e');
      return false; // On error, assume it's not a favorite
    }
  }

  /// Toggles the favorite status for a given recipe in Firestore.
  /// Notifies the caller about the new status via a callback.
  Future<void> toggleFavorite({
    required BuildContext context,
    required Recipe recipe,
    required Function(bool) onFavoriteStatusChanged,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to save favorites')),
        );
        return;
      }

      final userFavoritesDocRef = _firestore
          .collection(_favoritesCollectionName)
          .doc(user.uid);

      final docSnapshot = await userFavoritesDocRef.get();

      List<String> favoriteRecipeIds = [];
      bool currentIsFavorite = false;

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        if (data.containsKey('favoriteRecipeIds')) {
          favoriteRecipeIds = List<String>.from(data['favoriteRecipeIds'] ?? []);
          currentIsFavorite = favoriteRecipeIds.contains(recipe.id);
        }
      }

      if (currentIsFavorite) {
        // Remove from favorites
        favoriteRecipeIds.remove(recipe.id);
        await userFavoritesDocRef.set(
          {'favoriteRecipeIds': favoriteRecipeIds},
          SetOptions(merge: true),
        );
        onFavoriteStatusChanged(false); // Notify about new status
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${recipe.name} removed from favorites'),
            backgroundColor: Colors.grey[700],
          ),
        );
      } else {
        // Add to favorites
        favoriteRecipeIds.add(recipe.id);
        await userFavoritesDocRef.set(
          {'favoriteRecipeIds': favoriteRecipeIds},
          SetOptions(merge: true),
        );
        onFavoriteStatusChanged(true); // Notify about new status
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${recipe.name} added to favorites'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating favorites')),
      );
    }
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool showIngredients = true;
  bool isFavorite = false;
  bool isLoading = true;
  Map<int, int> ingredientQuantities = {};

  late final RecipeFavoriteService _favoriteService;

  @override
  void initState() {
    super.initState();
    _favoriteService = RecipeFavoriteService();
    // Initialize quantities for all ingredients
    for (int i = 0; i < widget.recipe.ingredients.length; i++) {
      ingredientQuantities[i] = int.tryParse(widget.recipe.ingredients[i]['quantity']?.toString() ?? '1') ?? 1;
    }
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


  // Calculate adjusted nutrition values based on ingredient quantities
  Map<String, dynamic> getAdjustedNutrition() {
    double totalCalories = 0;
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;

    for (int i = 0; i < widget.recipe.ingredients.length; i++) {
      final ingredient = widget.recipe.ingredients[i];
      final quantity = ingredientQuantities[i] ?? 1;
      final originalQuantity = int.tryParse(ingredient['quantity']?.toString() ?? '1') ?? 1;
      final multiplier = quantity / originalQuantity;

      // Assuming each ingredient has nutrition info - adjust based on your Recipe model
      totalCalories += (ingredient['calories'] ?? 0) * multiplier;
      totalCarbs += (ingredient['carbs'] ?? 0) * multiplier;
      totalProtein += (ingredient['protein'] ?? 0) * multiplier;
      totalFat += (ingredient['fat'] ?? 0) * multiplier;
    }

    return {
      'calories': totalCalories.round(),
      'carbs': totalCarbs.round(),
      'protein': totalProtein.round(),
      'fat': totalFat.round(),
    };
  }

  void updateIngredientQuantity(int index, int change) {
    setState(() {
      final currentQuantity = ingredientQuantities[index] ?? 1;
      final newQuantity = currentQuantity + change;
      if (newQuantity >= 0) {
        ingredientQuantities[index] = newQuantity;
      }
    });
  }

  Future<void> _showDateModal() async {
    final results = await showMultiDatePickerModal(
      context,
      RecipeId: widget.recipe.id,
      RecipeCategory: widget.recipe.category,
    );

    if (results != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.recipe.name} added to meal plan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adjustedNutrition = getAdjustedNutrition();

    return Scaffold(
      body: Stack(
        children: [
          // Background image with placeholder
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: widget.recipe.imageUrl != null && widget.recipe.imageUrl!.isNotEmpty
                ? Image.network(
              widget.recipe.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildPlaceholder();
              },
            )
                : _buildPlaceholder(),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      IconButton(
                        icon: isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        // onPressed: isLoading ? null : _toggleFavorite,
                        onPressed:  isLoading ? null : () {
                          _favoriteService.toggleFavorite(
                          context: context,
                          recipe: widget.recipe,
                          onFavoriteStatusChanged: (isFav) {
                            setState(() {
                              isFavorite = isFav;
                            });
                          },
                        );},
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Content card
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Recipe header
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.recipe.name,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.orange, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.5',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.recipe.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Nutrition info row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildNutritionItem('${adjustedNutrition['carbs']}g carbs'),
                                _buildNutritionItem('${adjustedNutrition['protein']}g proteins'),
                                _buildNutritionItem('${adjustedNutrition['calories']} kcal'),
                                _buildNutritionItem('${adjustedNutrition['fat']}g fats'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Tab buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => setState(() => showIngredients = true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: showIngredients ? Colors.green : Colors.grey[200],
                                  foregroundColor: showIngredients ? Colors.white : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Ingredients'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => setState(() => showIngredients = false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !showIngredients ? Colors.green : Colors.grey[200],
                                  foregroundColor: !showIngredients ? Colors.white : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Instructions'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Content based on selected tab
                      Expanded(
                        child: showIngredients ? _buildIngredientsTab() : _buildInstructionsTab(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 16),
          Text(
            'Recipe Image',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Image will load from Firebase',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String text) {
    return Column(
      children: [
        Icon(
          Icons.local_fire_department,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Ingredients',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            '${widget.recipe.ingredients.length} Items',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: widget.recipe.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = widget.recipe.ingredients[index];
              final quantity = ingredientQuantities[index] ?? 1;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Ingredient icon/image
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getIngredientColor(ingredient['name'] ?? ''),
                        shape: BoxShape.circle,
                      ),
                      child: ingredient['imageUrl'] != null && ingredient['imageUrl'].isNotEmpty
                          ? ClipOval(
                        child: Image.network(
                          ingredient['imageUrl'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _getIngredientIcon(ingredient['name'] ?? ''),
                              color: Colors.white,
                              size: 20,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Icon(
                              _getIngredientIcon(ingredient['name'] ?? ''),
                              color: Colors.white,
                              size: 20,
                            );
                          },
                        ),
                      )
                          : Icon(
                        _getIngredientIcon(ingredient['name'] ?? ''),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Ingredient name
                    Expanded(
                      child: Text(
                        ingredient['name'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Quantity controls
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => updateIngredientQuantity(index, -1),
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.grey[600],
                        ),
                        Text(
                          '$quantity',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => updateIngredientQuantity(index, 1),
                          icon: const Icon(Icons.add_circle_outline),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.recipe.instructions.length,
              itemBuilder: (context, index) {
                final instruction = widget.recipe.instructions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          instruction,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // const SizedBox(width: 12),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _showDateModal();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green ,
                foregroundColor: Colors.white ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add to meal plan'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getIngredientColor(String ingredientName) {
    // Simple color mapping based on ingredient name
    final colors = [
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.teal,
    ];
    return colors[ingredientName.hashCode % colors.length];
  }

  IconData _getIngredientIcon(String ingredientName) {
    // Simple icon mapping based on ingredient name
    final lowercaseName = ingredientName.toLowerCase();
    if (lowercaseName.contains('tortilla') || lowercaseName.contains('chip')) {
      return Icons.crop_square;
    } else if (lowercaseName.contains('avocado')) {
      return Icons.eco;
    } else if (lowercaseName.contains('cabbage') || lowercaseName.contains('lettuce')) {
      return Icons.grass;
    } else if (lowercaseName.contains('onion')) {
      return Icons.circle;
    } else if (lowercaseName.contains('peanut') || lowercaseName.contains('nut')) {
      return Icons.grain;
    } else {
      return Icons.restaurant;
    }
  }
}