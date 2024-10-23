import 'package:dj_lunchbox/features/authentication/new_user_account_setup/screens/gender.dart';
import 'package:dj_lunchbox/features/authentication/onboarding/onboarding_screen.dart';
import 'package:dj_lunchbox/utils/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'features/authentication/new_user_account_setup/screens/goal.dart';

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
      home: OnboardingScreen(),
      //home: GenderPage(currentPage: 1, totalPages: 5,),
    );
  }
}
