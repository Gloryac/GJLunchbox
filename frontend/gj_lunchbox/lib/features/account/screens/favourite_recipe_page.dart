import 'package:dj_lunchbox/features/mealPlan/widget/suggestedRecipes/recipeCard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../recipe/model/recipe.dart';
// import '../../recipe/widgets/suggestedRecipes/recipeCard.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // This will hold your favorite recipes
  // For now, using empty list as placeholder
  // List<Map<String, dynamic>> favoriteRecipes = [];
  late Future<List<Recipe>> favoriteRecipes;

  @override
  void initState() {
    super.initState();
    // TODO: Load favorite recipes from your data source
    favoriteRecipes =  getFavoriteRecipes();
  }
  void _refreshFavorites() {
    setState(() {
      favoriteRecipes = getFavoriteRecipes();
    });
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If no user is logged in, return an empty list immediately.
        return [];
      }

      final userFavoritesDocRef = FirebaseFirestore.instance
          .collection('Favorites') // Ensure this matches your Firestore collection name
          .doc(user.uid);

      final docSnapshot = await userFavoritesDocRef.get();

      // Check if the document exists and contains the 'favoriteRecipeIds' field
      List<String> favoriteRecipeIds = [];
      if (docSnapshot.exists && docSnapshot.data() != null && docSnapshot.data()!.containsKey('favoriteRecipeIds')) {
        favoriteRecipeIds = List<String>.from(docSnapshot.data()!['favoriteRecipeIds'] ?? []);
      } else {
        // If the document or the field doesn't exist, there are no favorites
        return [];
      }

      if (favoriteRecipeIds.isEmpty) {
        return [];
      }

      // Now, fetch the actual Recipe documents from the 'recipes' collection
      final recipesCollectionRef = FirebaseFirestore.instance.collection('recipes');


      final querySnapshot = await recipesCollectionRef
          .where(FieldPath.documentId, whereIn: favoriteRecipeIds)
          .get();

      // Map the DocumentSnapshots to a list of Recipe objects
      final favoriteRecipes = querySnapshot.docs
          .map((doc) => Recipe.fromFirestore(doc))
          .toList();

      return favoriteRecipes;
    } catch (e) {
      print("Error fetching favorite recipes: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      // body: favoriteRecipes.isEmpty ? _buildEmptyState() : _buildFavoritesList(),
      body: FutureBuilder<List<Recipe>>(
        future: favoriteRecipes, // Use the Future directly
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error); // For debugging
            return Center(
                child: Text(
                    'Error loading favorites: ${snapshot.error}. Check Firestore rules.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If data is null or empty, show the empty state
            return _buildEmptyState();
          } else {
            // If data is available, pass it to the list builder
            final List<Recipe> recipes = snapshot.data!;
            return _buildFavoritesList(recipes);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Start adding recipes to your favorites\nand they\'ll appear here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Explore Recipes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(List<Recipe> recipes) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${recipes.length} Recipe${recipes.length == 1 ? '' : 's'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(

              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                // return _buildRecipeCard(recipe);
                return RecipeCard(recipe: recipe,onFavoriteToggled: _refreshFavorites,);
              },

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to recipe detail page
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => RecipeDetailScreen(recipe: recipe),
        //   ),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    // Image placeholder or actual image
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        color: Colors.grey[300],
                      ),
                      child: recipe['imageUrl'] != null && recipe['imageUrl'].isNotEmpty
                          ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          recipe['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        ),
                      )
                          : _buildImagePlaceholder(),
                    ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          _removeFromFavorites(recipe);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Recipe Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['name'] ?? 'Recipe Name',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe['description'] ?? 'Recipe description',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${recipe['cookTime'] ?? '30'} min',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 14,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${recipe['calories'] ?? '0'} cal',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 32,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 8),
          Text(
            'Recipe Image',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromFavorites(Map<String, dynamic> recipe) {
    setState(() {
      // favoriteRecipes.remove(recipe);
    });

    // TODO: Remove from your data source
    // await removeFavoriteRecipe(recipe['id']);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${recipe['name']} removed from favorites'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[700],
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implement undo functionality
            setState(() {
              // favoriteRecipes.add(recipe);
            });
          },
        ),
      ),
    );
  }
}