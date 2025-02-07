import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../recipe/model/recipe.dart';

class NutritionInfo extends StatelessWidget {
  final Recipe recipe;

  const NutritionInfo({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NutritionItem(
            label: 'Calories',
            value: recipe.calories,
            icon: Icons.local_fire_department_outlined,
          ),
          _NutritionItem(
            label: 'Proteins',
            value: recipe.proteins,
            icon: Icons.fitness_center_outlined,
          ),
          _NutritionItem(
            label: 'Carbs',
            value: recipe.carbs,
            icon: Icons.grain_outlined,
          ),
          _NutritionItem(
            label: 'Fats',
            value: recipe.fats,
            icon: Icons.opacity_outlined,
          ),
        ],
      ),
    );
  }
}

class _NutritionItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _NutritionItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}