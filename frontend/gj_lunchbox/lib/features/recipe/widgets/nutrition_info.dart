import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';
import '../model/recipe.dart';

class NutritionInfo extends StatelessWidget {
  final Recipe recipe;
  final bool isCompact;

  const NutritionInfo({
    super.key,
    required this.recipe,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isCompact
          ? const EdgeInsets.symmetric(horizontal: 2, vertical: 2)
          : const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: isCompact ? _buildCompactLayout() : _buildDefaultLayout(),
    );
  }

  Widget _buildDefaultLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutritionItem(
          icon: Icons.local_fire_department,
          value: recipe.calories,
          color: Colors.orange,
        ),
        _buildNutritionItem(
          icon: Icons.grain,
          value: '${recipe.carbs}g',
          color: Colors.brown,
        ),
        _buildNutritionItem(
          icon: Icons.egg_outlined,
          value: '${recipe.proteins}g',
          color: Colors.red,
        ),
        _buildNutritionItem(
          icon: Icons.water_drop,
          value: '${recipe.fats}g',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 6) / 4; // Account for padding

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNutritionItem(
              icon: Icons.local_fire_department,
              value: recipe.calories,
              color: Colors.orange,
              isCompact: true,
              maxWidth: itemWidth,
            ),
            _buildNutritionItem(
              icon: Icons.grain,
              value: '${recipe.carbs}g',
              color: Colors.brown,
              isCompact: true,
              maxWidth: itemWidth,
            ),
            _buildNutritionItem(
              icon: Icons.egg_outlined,
              value: '${recipe.proteins}g',
              color: Colors.red,
              isCompact: true,
              maxWidth: itemWidth,
            ),
            _buildNutritionItem(
              icon: Icons.water_drop,
              value: '${recipe.fats}g',
              color: Colors.blue,
              isCompact: true,
              maxWidth: itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildNutritionItem({
    required IconData icon,
    required String value,
    required Color color,
    bool isCompact = false,
    double? maxWidth,
  }) {
    return Container(
      constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: isCompact ? 14 : 20,
          ),
          const SizedBox(height: 1), // Reduced from 2
          Text(
            value,
            style: isCompact
                ? AppTextTheme.textStyles.labelSmall?.copyWith(
                    fontSize: 8,
                    height: 1.1, // Tighter line height
                  )
                : AppTextTheme.textStyles.labelSmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
