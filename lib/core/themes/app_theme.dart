import 'package:first_project/core/themes/text_style.dart';
import 'package:flutter/material.dart';

class AppTheme {

    // %%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%

    // oooooooooooooooo LIGHT ooooooooooooooooooo
    static ThemeData lightTheme = ThemeData(
        brightness: Brightness.light,

        textTheme: TextTheme(
            titleLarge: AppTextStyles.title,
            titleMedium: AppTextStyles.subtitle,
            bodyMedium: AppTextStyles.body
        )
    );
    // oooooooooooooooo END - LIGHT ooooooooooooooooooo


    // oooooooooooooooo DARK ooooooooooooooooooo
    static ThemeData darkTheme = ThemeData(
        brightness: Brightness.dark,

        textTheme: TextTheme(
            titleLarge: AppTextStyles.title,
            titleMedium: AppTextStyles.subtitle,
            bodyMedium: AppTextStyles.body
        )
    );
    // oooooooooooooooo END - DARK ooooooooooooooooooo

    // %%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%
}