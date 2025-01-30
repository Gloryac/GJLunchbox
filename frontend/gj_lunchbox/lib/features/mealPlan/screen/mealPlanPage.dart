import 'dart:convert';

import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/dateWidget.dart';

import '../widget/mealWidget.dart';
import 'mealCreationPage.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  DateTime _selectedDate = DateTime.now();
  List<Meal> _meals = [];

  get http => null;

  @override
  void initState() {
    super.initState();
    _fetchMeals();
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
                meals: _meals,
                selectedDate: _selectedDate,
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

  void _handleDateTapped(DateTime date) {
    setState(() {
      _selectedDate = date;
      _fetchMeals();
    });
  }

  Future<void> _fetchMeals() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/meals?date=${DateFormat('yyyy-MM-dd').format(_selectedDate)}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        _meals = data.map((json) => Meal.fromJson(json)).toList();
      });
    } else {
      // Handle error
    }
  }
}

