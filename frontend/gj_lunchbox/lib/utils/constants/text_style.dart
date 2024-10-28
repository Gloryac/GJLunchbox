import 'package:flutter/material.dart';



class AppTextTheme{
  AppTextTheme._();
  static TextTheme textStyles= TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 38, fontWeight: FontWeight.bold),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.bold),
    headlineSmall: const TextStyle().copyWith(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w400),
    bodySmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    labelMedium: const TextStyle().copyWith(fontSize: 15, fontWeight: FontWeight.w600),
    labelSmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400),

  );

}