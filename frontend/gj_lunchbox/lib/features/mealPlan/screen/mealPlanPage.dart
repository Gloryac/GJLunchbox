import 'dart:convert';

import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/dateWidget.dart';

import '../widget/mealWidget.dart';
import 'mealCreationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../recipe/model/recipe.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  DateTime _selectedDate = DateTime.now();
  List<Meal> _meals = [];
  Recipe? recipe;

  String selectedCategory = 'Lunch';



  Future<Recipe?> getMeal({required DateTime date, required String category, required BuildContext context}) async {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    if (user != null) {
      final userId = user.uid;
      String  mealPlanCategory = "Snack_meal_plan";

      if(category == "Lunch"){
        mealPlanCategory = category + "_meal_plan";
      }

      try {
        final collectionRef = firestore.collection(mealPlanCategory);
        final userDocRef = collectionRef.doc(userId);

        // 1. Get the user's meal plan document for this category
        final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await userDocRef.get();

        if (!docSnapshot.exists || docSnapshot.data() == null) {
          print('Meal plan document does not exist for user $userId in category $mealPlanCategory.');
          return null; // No meal plan found for this user/category
        }

        final data = docSnapshot.data()!;

        final String formattedDateKey = DateTime.utc(date.year, date.month, date.day).toIso8601String();

        // 2. Get the RecipeId from the document using the formatted date key
        final String? recipeId = data[formattedDateKey] as String?;

        if (recipeId == null) {
          print('No recipe found for date $formattedDateKey in category $mealPlanCategory for user $userId.');
          return null; // No recipe assigned for this specific date
        }

        // 3. Fetch the actual recipe document
        final recipeRef = firestore.collection("recipes");
        final DocumentSnapshot<Map<String, dynamic>> recipeDoc = await recipeRef.doc(recipeId).get();

        if (!recipeDoc.exists || recipeDoc.data() == null) {
          print('Recipe document with ID $recipeId not found in "recipes" collection.');
          return null; // Recipe document itself not found
        }

        // 4. Convert the recipe document to a Recipe object and return it
        return Recipe.fromFirestore(recipeDoc);

      } catch (e) {
        print('Error getting meal from Firebase: $mealPlanCategory, $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error retrieving meal: $e')),
        );
        return null;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to view your meal plan')),
      );
      return null; // User not logged in
    }
  }

  // get http => null;
  Future<void> _fetchAndSetRecipe() async {
    final fetchedRecipe = await getMeal(
      date: _selectedDate,
      category: selectedCategory,
      context: context,
    );

    print("the category is $selectedCategory and the date is $_selectedDate");
    setState(() {
      recipe = fetchedRecipe;
    });
  }


  @override
  void initState()  {
    super.initState();
    // _fetchMeals();
    _fetchAndSetRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            TextStrings.mealPlan,
            style: AppTextTheme.textStyles.headlineMedium,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
        children: [
            Text(
                TextStrings.mealPlanWord,
                style: AppTextTheme.textStyles.bodyMedium,),
            const SizedBox(height: 16.0),
            DateWidget(
              selectedDate: _selectedDate,
              onDateTapped: _handleDateTapped,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: MealWidget(
                // meals: _meals,
                recipe: recipe,
                selectedDate: _selectedDate,
                  onCategoryChange:  _handleCategoryChange,
                onMakePlate: (category) {
                  // Navigate to a meal creation screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealCreationPage(
                        date: _selectedDate,
                        category: category,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDateTapped(DateTime date) async {
    setState(() {
      _selectedDate = date;
      // _fetchMeals();
      _fetchAndSetRecipe();
    });
  }
  void  _handleCategoryChange(String category) async{
    setState(() {
      selectedCategory = category;
      _fetchAndSetRecipe();
    });
  }

  // Future<void> _fetchMeals() async {
  //   final response = await http.get(Uri.parse('http://localhost:3000/api/meals?date=${DateFormat('yyyy-MM-dd').format(_selectedDate)}'));
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as List;
  //     setState(() {
  //       _meals = data.map((json) => Meal.fromJson(json)).toList();
  //     });
  //   } else {
  //     // Handle error
  //   }
  // }
}

