import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.black54;
  static const Color divider = Color(0xFFE0E0E0);
  static const Color likeRed = Color(0xFFFF0000);
  
  // Instagram gradient colors
  static const Color gradientStart = Color(0xFFFEDA75);
  static const Color gradientMiddle1 = Color(0xFFFA7E1E);
  static const Color gradientMiddle2 = Color(0xFFD62976);
  static const Color gradientMiddle3 = Color(0xFF962FBF);
  static const Color gradientEnd = Color(0xFF4F5BD5);

  static const LinearGradient storyGradient = LinearGradient(
    colors: [
      gradientStart,
      gradientMiddle1,
      gradientMiddle2,
      gradientMiddle3,
      gradientEnd,
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}
