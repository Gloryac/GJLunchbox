import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe{
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final double cookTime;
  final String calories;
  final String proteins;
  final String carbs;
  final String fats;
  final List<Map<String, dynamic>> ingredients;
  final List <String> instructions;
  //final String author;
  //final bool isFeatured;

  Recipe({
     required this.id,
     required this.name,
     required this.description,
     required this.category,
     required this.imageUrl,
     required this.cookTime,
     required this.calories,
     required this.proteins,
     required this.carbs,
     required this.fats,
     required this.ingredients,
     required this.instructions,
     //required this.author,
     //this.isFeatured = false
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      name: data['Recipe Name'] ?? '',
      description: data['Description'] ?? '',
      category: data['Category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      cookTime: data['Time (mins)'] ?? 0,
      calories: data['Calories'] ?? 0,
      proteins: (data['Proteins'] ?? 0),
      carbs: (data['Carbs'] ?? 0),
      fats: (data['Fats'] ?? 0),
      ingredients: List<Map<String, dynamic>>.from(data['Ingredients'] ?? []),
      instructions: List<String>.from(data['Instructions'] ?? []),
      //author: data['author'] ?? '',
      //isFeatured: data['isFeatured'] ?? false,
    );
  }
}