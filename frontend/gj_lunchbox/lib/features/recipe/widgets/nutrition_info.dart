import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';

import '../model/recipe.dart';

class NutritionInfo extends StatelessWidget {
  final Recipe recipe;

  const NutritionInfo({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem(
            icon: Icons.local_fire_department,
            value: recipe.calories,
            //label: 'Calories',
            color: Colors.orange,
          ),
          _buildNutritionItem(
            icon: Icons.grain,
            value: '${recipe.carbs}g',
            //label: 'Carbs',
            color: Colors.brown,
          ),
          _buildNutritionItem(
            icon: Icons.egg_outlined,
            value: '${recipe.proteins}g',
            //label: 'Protein',
            color: Colors.red,
          ),
          _buildNutritionItem(
            icon: Icons.water_drop,
            value: '${recipe.fats}g',
            //label: 'Fat',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem({
    required IconData icon,
    required String value,
    //required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color,),
        const SizedBox(height: 4),
        Text(value, style: AppTextTheme.textStyles.labelSmall),
        //Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
