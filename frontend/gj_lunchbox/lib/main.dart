import 'package:dj_lunchbox/features/authentication/new_user_account_setup/screens/gender.dart';
import 'package:dj_lunchbox/features/authentication/new_user_account_setup/screens/height.dart';
import 'package:dj_lunchbox/features/authentication/onboarding/onboarding_screen.dart';
import 'package:dj_lunchbox/utils/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:dj_lunchbox/features/authentication/user_management/login.dart';
import 'features/authentication/new_user_account_setup/screens/dob.dart';
import 'features/authentication/new_user_account_setup/screens/goal.dart';
import 'features/authentication/new_user_account_setup/screens/preparingPlan.dart';
import 'features/authentication/new_user_account_setup/screens/weight.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('user is currently signed out');
    } else {
      print(user);
      print('user is currently signed in');
    }
  });

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
      // Change the home widget based on your intended flow
      // home: LoginPage(), // Uncomment to use LoginPage
      // home: OnboardingScreen(), // Uncomment to use OnboardingScreen
      // home: PreparingPlanPage(), // Uncomment to use PreparingPlanPage
      home: WeightPage(currentPage: 1, totalPages: 5, value: 60.0), // Default home
      // home: HeightPage(currentPage: 1, totalPages: 5, initialValue: 50, minValue: 0, maxValue: 200), // Uncomment for HeightPage
    );
  }
}
