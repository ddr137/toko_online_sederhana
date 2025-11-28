import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/shared/extensions/context_ext.dart';

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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: context.colorScheme.primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: context.colorScheme.primaryContainer,
        elevation: 0,
      ),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          foregroundColor: context.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: context.colorScheme.primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: context.colorScheme.primaryContainer,
        elevation: 0,
      ),
    );
  }
}

