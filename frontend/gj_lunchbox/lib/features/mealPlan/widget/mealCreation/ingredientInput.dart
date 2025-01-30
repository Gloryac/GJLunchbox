import 'package:flutter/material.dart';
//import 'package:dj_lunchbox/models/ingredient_item.dart';

class IngredientInput extends StatelessWidget {
  final Function(String) onSubmitted;
  final int ingredientCount;

  const IngredientInput({
    super.key,
    required this.onSubmitted,
    required this.ingredientCount,
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Ingredient ${ingredientCount + 1}',
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}