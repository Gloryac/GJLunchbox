import 'package:dj_lunchbox/features/authentication/new_user_account_setup/screens/gender.dart';
import 'package:dj_lunchbox/features/authentication/new_user_account_setup/screens/height.dart';
import 'package:dj_lunchbox/features/authentication/onboarding/onboarding_screen.dart';
import 'package:dj_lunchbox/utils/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'features/authentication/new_user_account_setup/screens/dob.dart';
import 'features/authentication/new_user_account_setup/screens/goal.dart';
import 'features/authentication/new_user_account_setup/screens/preparingPlan.dart';
import 'features/authentication/new_user_account_setup/screens/weight.dart';

void main(){
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //home: OnboardingScreen(),
      //home: PreparingPlanPage(),
      home: WeightPage(currentPage: 1, totalPages: 5, value: 60.0,),
      //home: HeightPage(currentPage: 1, totalPages: 5, initialValue: 50, minValue: 0, maxValue: 200,),
    );
  }
}
