import 'package:first_project/core/themes/color_palette.dart';
import 'package:first_project/core/themes/text_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%

  // ooooooooooooooo LIGHT THEME oooooooooooooooooooo
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.divider,

    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white70,
    ),

    colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white, // Text on primary color (usually white)
        secondary: AppColors.secondary,
        onSecondary: Colors.black, // Text on secondary color
        error: AppColors.deepVineRed, // Custom deep vine red for errors
        onError: Colors.white, // Text on error color
        surface: AppColors.lightBackground, // Background color for surfaces (cards, etc.)
        onSurface: AppColors.lightText, // Text on surfaces
        surfaceContainerHigh: AppColors.lightBorder,
        surfaceContainerHighest: AppColors.lightBorderHigh,
        surfaceContainer: AppColors.lightCard, 
    ),

    textTheme: TextTheme(
        headlineLarge: AppTextStyles.mainTitle,
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.small,
        headlineSmall: AppTextStyles.coloredTitle, // Colored title (custom)
    ),

    cardTheme: CardTheme(
        color: AppColors.lightCard,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightFloatingButonBackground,
        foregroundColor: Colors.white
    ),

  );
  // ooooooooooooooo END - LIGHT THEME oooooooooooooooooooo




  // oooooooooooooo DARK THEME ooooooooooooooooooooo
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.divider,

    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white70,
    ),

    colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white, // Text on primary color (usually white)
        secondary: AppColors.secondary,
        onSecondary: Colors.black, // Text on secondary color
        error: AppColors.deepVineRed, // Custom deep vine red for errors
        onError: Colors.white, // Text on error color
        surface: AppColors.darkBackground, // Background color for surfaces (cards, etc.)
        onSurface: AppColors.darkText, // Text on surfaces
        surfaceContainerHigh: AppColors.darkBorder,
        surfaceContainerHighest: AppColors.darkBorderHigh,
        surfaceContainer: AppColors.darkCard,
    ),

    textTheme: TextTheme(
        headlineLarge: AppTextStyles.mainTitle,
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.small,
        headlineSmall: AppTextStyles.coloredTitle, // Colored title (custom)
    ),

    cardTheme: CardTheme(
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkFloatingBackground,
        foregroundColor: Colors.black
    ),

  );
  // oooooooooooooo END - DARK THEME ooooooooooooooooooooo

  // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%
}
