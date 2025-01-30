class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final int calories;
  final int cookingTime;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.cookingTime,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      calories: json['calories'] as int,
      cookingTime: json['cookingTime'] as int,
      ingredients: List<String>.from(json['ingredients'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'calories': calories,
      'cookingTime': cookingTime,
      'ingredients': ingredients,
    };
  }
}