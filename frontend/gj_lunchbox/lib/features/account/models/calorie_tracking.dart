class CalorieTracking{
  final int score;
  final double carbs;
  final double proteins;
  final double vitamins;
  final List<CalorieEntry>entries;

  CalorieTracking({
    required this.score,
    required this.carbs,
    required this.vitamins,
    required this.proteins,
    required this.entries,
});
}class UserProfile{
  final String name;
  final String email;
  final double weight;
  final double height;
  final int age;
  final String? imageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.weight,
    required this.height,
    required this.age,
    this.imageUrl,
});
}

class CalorieEntry{
  final DateTime date;
  final int calories;

  CalorieEntry({
    required this.date,
    required this.calories,
});
}