import 'dart:convert';

import '../model/suggestedRecipe.dart';

class RecipeService {
  static const String baseUrl = 'YOUR_API_BASE_URL';

  get http => null;

  Future<List<Recipe>> getRecipeSuggestions({
    required List<String> ingredients,
    required String mealType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recipes/suggest'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ingredients': ingredients,
          'mealType': mealType,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }
}