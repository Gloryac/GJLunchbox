import 'package:dj_lunchbox/features/mealPlan/screen/mealPlanPage.dart';
import 'package:dj_lunchbox/features/recipe/screen/recipePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/home/screen/home.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {

    final controller  =Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Obx(
          ()=> NavigationBar(
           // height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            destinations: [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.shop), label: 'Recipe'),
              NavigationDestination(icon: Icon(Iconsax.calendar), label: 'Meal Plan'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Account'),
            ],
          ),
        ),
      ),
    body: Obx(()=>controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;
  final screens = [const HomeScreen(),const RecipePage(),const MealPlanPage(),const HomeScreen()];
}
