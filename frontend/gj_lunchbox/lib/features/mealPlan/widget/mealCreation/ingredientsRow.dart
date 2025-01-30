import 'package:flutter/material.dart';
//import 'package:dj_lunchbox/models/ingredient_item.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';

import '../../model/ingredientItem.dart';

class IngredientRow extends StatelessWidget {
  final IngredientItem ingredient;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const IngredientRow({
    super.key,
    required this.ingredient,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                ingredient.name,
                style: AppTextTheme.textStyles.bodyMedium,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: ingredient.quantity > 1 ? onDecrement : null,
          ),
          Text(
            ingredient.quantity.toString(),
            style: AppTextTheme.textStyles.bodyMedium,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}