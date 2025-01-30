import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';

class MealWidget extends StatefulWidget {
  const MealWidget({
    super.key,
    required this.meals,
    required this.selectedDate,
    required this.onMakePlate,
  });

  final List<Meal> meals;
  final DateTime selectedDate;
  final Function(String category) onMakePlate;

  @override
  State<MealWidget> createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  String selectedCategory = 'Breakfast';

  @override
  Widget build(BuildContext context) {
    final categories = ['Breakfast', 'Lunch', 'Supper', 'Snacks'];

    // Filter meals for the selected category and date
    final mealsForCategory = widget.meals.where((meal) {
      return meal.type.toLowerCase() == selectedCategory.toLowerCase() &&
          meal.date.day == widget.selectedDate.day &&
          meal.date.month == widget.selectedDate.month &&
          meal.date.year == widget.selectedDate.year;
    }).toList();

    final bool hasMeal = mealsForCategory.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Horizontal category buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? AppColors.green : AppColors.gray,
                    foregroundColor: isSelected ? AppColors.white : AppColors.lightGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Text(category),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16.0),

        // Display meal or empty state
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: hasMeal
                ? _buildMealContent(mealsForCategory.first)
                : _buildEmptyState(selectedCategory, widget.onMakePlate),
          ),
        ),
      ],
    );
  }

  Widget _buildMealContent(Meal meal) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Meal image (placeholder)
        Image.asset(
          ImageString.emoji,
          width: 100,
          height: 100,
        ),
        const SizedBox(width: 16.0),

        // Meal details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.local_fire_department, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text('${meal.calories} Kcal'),
                  const SizedBox(width: 16.0),
                  const Icon(Icons.timer, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text('${meal.prepTime} Min'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String category, Function(String category) onMakePlate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          ImageString.emoji,
          width: 130,
          height: 100,
        ),
        const SizedBox(height: 8.0),
        Text(
          TextStrings.mealPlanEmpty,
          style: AppTextTheme.textStyles.bodyMedium
        ),
        const SizedBox(height: 16.0),
        TextButton(
          onPressed: () => onMakePlate(category),
          child: Text(
            TextStrings.mealPlanMakePlate,
            style: AppTextTheme.textStyles.labelMedium?.copyWith(color: AppColors.orange)

          ),
        ),
      ],
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
