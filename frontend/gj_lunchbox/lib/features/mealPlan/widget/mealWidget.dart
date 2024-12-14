import 'package:flutter/material.dart';

class MealWidget extends StatelessWidget {
  const MealWidget({super.key, required this.meals});
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var meal in meals)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMealSection(meal),
              SizedBox(height: 16.0),
            ],
          ),
      ],
    );
  }

  Widget _buildMealSection(Meal meal) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/placeholder.jpg',
            width: 100,
            height: 100,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${meal.type} Meal'),
                SizedBox(height: 8.0),
                Text(meal.name),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 16.0),
                    SizedBox(width: 4.0),
                    Text('${meal.calories} Kcal'),
                    SizedBox(width: 16.0),
                    Icon(Icons.timer, size: 16.0),
                    SizedBox(width: 4.0),
                    Text('${meal.prepTime} Min'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Meal {
  final String type;
  final String name;
  final int calories;
  final int prepTime;
  final DateTime date;

  Meal({
    required this.type,
    required this.name,
    required this.calories,
    required this.prepTime,
    required this.date,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      type: json['type'],
      name: json['name'],
      calories: json['calories'],
      prepTime: json['prepTime'],
      date: DateTime.parse(json['date']),
    );
  }
}
