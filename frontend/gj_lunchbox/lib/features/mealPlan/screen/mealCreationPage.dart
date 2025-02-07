import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dj_lunchbox/features/mealPlan/screen/suggestedRecipes.dart';
import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/dateFormatter.dart';
import '../../recipe/model/recipe.dart';
import '../model/ingredientItem.dart';
//import '../model/suggestedRecipe.dart';
import '../widget/mealCreation/ingredientInput.dart';

class MealCreationPage extends StatefulWidget {
  final DateTime date;
  final String category;

  const MealCreationPage({
    super.key,
    required this.date,
    required this.category,
  });

  @override
  State<MealCreationPage> createState() => _MealCreationPageState();
}

class _MealCreationPageState extends State<MealCreationPage> {
  List<IngredientItem> ingredients = List.generate(4, (index) => IngredientItem(name: ""));
  List<Recipe> recipes = [];
  String errorMessage = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      setState(() => isLoading = true);

      CollectionReference recipesCollection = FirebaseFirestore.instance.collection('recipes');
      QuerySnapshot snapshot = await recipesCollection.get();

      recipes = snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
      print('Fetched ${recipes.length} recipes');
      print('Hi');

      setState(() {
        isLoading = false;
        errorMessage = "";
      });
    } catch (error) {
      print('Error in _fetchRecipes: $error');
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching recipes: $error";
        recipes = [];
      });
    }
  }


  List<Recipe> _findMatchingRecipes(List<String> userIngredients) {
    print("\n=== Starting Recipe Search ===");
    print("User Ingredients: $userIngredients");

    if (userIngredients.isEmpty) {
      print("❌ No user ingredients provided");
      return [];
    }

    Set<String> userIngredientSet = userIngredients
        .map((i) => i.toLowerCase().trim())
        .toSet();

    print("\nNormalized User Ingredients: $userIngredientSet");

    // Filter recipes that contain ALL user ingredients
    List<Recipe> matchingRecipes = recipes.where((recipe) {
      print("\nChecking Recipe: ${recipe.name}");

      // Get all ingredient names from the recipe
      Set<String> recipeIngredients = recipe.ingredients
          .map((ingredient) => ingredient['name'].toString().toLowerCase().trim())
          .toSet();

      print("Recipe ingredients: $recipeIngredients");

      // Check if ALL user ingredients are present in the recipe
      bool hasAllIngredients = userIngredientSet.every((userIngredient) {
        bool found = recipeIngredients.any((recipeIngredient) =>
        recipeIngredient.contains(userIngredient) ||
            userIngredient.contains(recipeIngredient));
        print("Checking for '$userIngredient': ${found ? '✅ Found' : '❌ Not found'}");
        return found;
      });

      print("Recipe ${recipe.name} has all ingredients: $hasAllIngredients");
      return hasAllIngredients;
    }).toList();

    print("\n=== Search Complete ===");
    print("Matching Recipes Found: ${matchingRecipes.length}");
    for (var recipe in matchingRecipes) {
      print("- ${recipe.name}");
    }

    return matchingRecipes;
  }
  String get buttonText => 'Find ${widget.category} Recipes';

  void _onSearchPressed() {
    print("Entering _onSearchPressed");
    print("Raw Ingredients List: $ingredients");

    List<String> nonEmptyIngredients = ingredients
        .where((item) => item.name.trim().isNotEmpty) // Filter FIRST
        .map((item) => item.name.trim().toLowerCase()) // THEN map and lowercase
        .toList();
    print("Ingredients before filtering: ${ingredients.map((i) => i.name)}");
    print("Non-empty ingredients: $nonEmptyIngredients");
    if (nonEmptyIngredients.isEmpty) {
      print("No valid ingredients entered, stopping search.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter at least one ingredient"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    List<Recipe> matchingRecipes = _findMatchingRecipes(nonEmptyIngredients);
    print("Matching Recipes Count: ${matchingRecipes.length}");

    if (matchingRecipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No recipes found with these ingredients."),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuggestedRecipesPage(
            mealType: widget.category,
            recipes: matchingRecipes,
          ),
        ),
      );
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
        title: Text(
          DateFormatter.formatMealPlanDate(widget.date),
          style: AppTextTheme.textStyles.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'What ingredients do you have today?',
                  style: AppTextTheme.textStyles.bodyLarge,
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.sentiment_satisfied_alt,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: IngredientInputField(
                    initialValue: ingredients[index].name,
                    onChanged: (value) {
                      setState(() {
                        ingredients[index].name = value;
                        print("Updated ingredients[$index]: ${ingredients[index].name}");
                      });
                    },
                    index: index,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading || recipes.isEmpty ? null : _onSearchPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}