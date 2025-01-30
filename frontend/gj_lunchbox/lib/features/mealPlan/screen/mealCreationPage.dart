import 'package:flutter/material.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';

import '../../../utils/helpers/dateFormatter.dart';
import '../model/ingredientItem.dart';
import '../widget/mealCreation/ingredientInput.dart';
import '../widget/mealCreation/ingredientsRow.dart';

class MealCreationPage extends StatefulWidget {
  final DateTime date;
  final String category;

  const MealCreationPage({
    super.key,
    required this.date,
    required this.category,
  });

  @override
  State<MealCreationPage> createState() => _MealCreationPageState();
}

class _MealCreationPageState extends State<MealCreationPage> {
  final List<IngredientItem> ingredients = [];

  String get buttonText {
    return 'Make ${widget.category[0].toUpperCase()}${widget.category.substring(1).toLowerCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          DateFormatter.formatMealPlanDate(widget.date),
          style: AppTextTheme.textStyles.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'What ingredients do you have today?',
                  style: AppTextTheme.textStyles.bodyLarge,
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.sentiment_satisfied_alt,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length + 1,
                itemBuilder: (context, index) {
                  if (index == ingredients.length) {
                    return IngredientInput(
                      ingredientCount: ingredients.length,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            ingredients.add(IngredientItem(name: value, quantity: 2));
                          });
                        }
                      },
                    );
                  }
                  return IngredientRow(
                    ingredient: ingredients[index],
                    onIncrement: () {
                      setState(() {
                        ingredients[index].quantity++;
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        if (ingredients[index].quantity > 1) {
                          ingredients[index].quantity--;
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement meal creation logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}