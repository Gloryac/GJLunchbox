import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final String category;
  final String? imageUrl;
  final double cookTime;
  final String calories;
  final String proteins;
  final String carbs;
  final String fats;
  final List<Map<String, dynamic>> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.cookTime,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    print("Raw Data from Firestore (doc.id: ${doc.id}): $data");
    print("Type of Ingredients: ${data['Ingredients'].runtimeType}");
    print("Value of Ingredients: ${data['Ingredients']}");

    // Handle Ingredients - KEY IMPROVEMENT:
    List<Map<String, dynamic>> ingredients = [];
    if (data['Ingredients'] is List) {
      ingredients = (data['Ingredients'] as List)
          .cast<Map<String, dynamic>>()
          .toList();
    } else if (data['Ingredients'] is String) {
      final ingredientStrings = (data['Ingredients'] as String).split(',');
      ingredients = ingredientStrings.map((ingredient) => {
        "name": ingredient.trim()
      }).toList();
      print("Ingredients converted from String: $ingredients");
    } else if (data['Ingredients'] != null) { // Handle other cases if needed
      print("Unexpected Ingredients Type: ${data['Ingredients'].runtimeType}");
    }

    // Handle Instructions (Improved):
    List<String> instructions = [];
    if (data['Instructions'] is List) {
      instructions = List<String>.from(data['Instructions']);
    } else if (data['Instructions'] is String) {
      instructions = [data['Instructions'] as String];
    } else if (data['Instructions'] != null) { // Handle other cases if needed
      print("Unexpected Instructions Type: ${data['Instructions'].runtimeType}");
    }


    return Recipe(
      id: doc.id,
      name: data['Recipe Name'] ?? '',
      description: data['Description'] ?? '',
      category: data['Category']?.toString() ?? '',
      imageUrl: data['imageUrl'],
      cookTime: (data['Time (mins)'] ?? 0).toDouble(),
      calories: data['Calories']?.toString() ?? '0',
      proteins: data['Proteins']?.toString() ?? '0',
      carbs: data['Carbs']?.toString() ?? '0',
      fats: data['Fats']?.toString() ?? '0',
      ingredients: ingredients,
      instructions: instructions,
    );
  }
}