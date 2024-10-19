import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_style.dart';

class AppTheme{
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    scaffoldBackgroundColor:AppColors.white,
    textTheme: AppTextTheme.textStyles,

  );
  static ThemeData darkTheme = ThemeData();
}