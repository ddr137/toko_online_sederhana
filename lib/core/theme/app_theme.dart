import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme(BuildContext context,[ColorScheme? dynamicScheme]) {

    return ThemeData(
      useMaterial3: true,
      colorScheme: dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: AppColors.primary(context),
          brightness: Brightness.light,
        ),
      fontFamily: AppFonts.getPoppins,
      fontFamilyFallback: AppFonts.fonts,
    );
  }

  static ThemeData darkTheme(BuildContext context,[ColorScheme? dynamicScheme]) {

    return ThemeData(
      useMaterial3: true,
      colorScheme: dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: AppColors.primary(context),
          brightness: Brightness.dark,
        ),
      fontFamily: AppFonts.getPoppins,
      fontFamilyFallback: AppFonts.fonts,
    );
  }
}
