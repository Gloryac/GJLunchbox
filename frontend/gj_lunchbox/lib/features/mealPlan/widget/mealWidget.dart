import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../recipe/model/recipe.dart';

class MealWidget extends StatefulWidget {
  const MealWidget({
    super.key,
    this.recipe,
    required this.selectedDate,
    required this.onMakePlate,
    this.onCategoryChange
  });
  final void Function(String category)? onCategoryChange;
  final Recipe? recipe;

  // final List<Meal> meals;
  final DateTime selectedDate;
  final Function(String category) onMakePlate;

  @override
  State<MealWidget> createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  String selectedCategory = 'Lunch';

  @override
  Widget build(BuildContext context) {
    print('MealWidget building. Recipe is: ${widget.recipe?.category}');
    final categories = [ 'Lunch', 'Snacks'];

    // Filter meals for the selected category and date
    // final mealsForCategory = widget.meals.where((meal) {
    //   return meal.type.toLowerCase() == selectedCategory.toLowerCase() &&
    //       meal.date.day == widget.selectedDate.day &&
    //       meal.date.month == widget.selectedDate.month &&
    //       meal.date.year == widget.selectedDate.year;
    // }).toList();

    // final bool hasMeal = mealsForCategory.isNotEmpty;

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
                    widget.onCategoryChange?.call(selectedCategory);
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
            child: widget.recipe != null
                ? _buildMealContent(widget.recipe!)
                : _buildEmptyState(selectedCategory, widget.onMakePlate),
          ),
        ),
      ],
    );
  }

  Widget _buildMealContent(Recipe recipe) {

    print('Displaying meal content for: ${recipe.name}');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Meal image (placeholder)
        // Image.asset(
        //   ImageString.emoji,
        //   width: 100,
        //   height: 100,
        // ),
        Image.network(
          recipe.imageUrl ?? '',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, object, stackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        ),
        const SizedBox(width: 16.0),

        // Meal details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.name,
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
                  Text('${recipe.calories} Kcal'),
                  const SizedBox(width: 16.0),
                  const Icon(Icons.timer, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text('${recipe.cookTime} Min'),
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
