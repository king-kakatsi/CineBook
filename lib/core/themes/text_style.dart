import 'package:flutter/widgets.dart';
import 'package:first_project/core/themes/color_palette.dart';

class AppTextStyles {

  // %%%%%%%%%%%%%%%% PROPERTIES %%%%%%%%%%%%%%%%%%%%%

    // oooooooooooo MAIN TITLE STYLE ooooooooooooooo
    static const TextStyle mainTitle = TextStyle(
        fontFamily: 'Raleway',
        fontSize: 20,
        fontWeight: FontWeight.w800, // Bold
        color: AppColors.darkText,
    );
    // oooooooooooo END - MAIN TITLE STYLE ooooooooooooooo


  // oooooooooooo TITLE STYLE ooooooooooooooo
  static const TextStyle title = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.lightText,
  );

  static const TextStyle coloredTitle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.secondary,
  );
  // oooooooooooo END - TITLE STYLE ooooooooooooooo


  // oooooooooooo SUBTITLE STYLE ooooooooooooooo
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.lightText,
  );
  // oooooooooooo END - SUBTITLE STYLE ooooooooooooooo


  // oooooooooooo BODY STYLE ooooooooooooooo
  static const TextStyle body = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.lightText,
  );
  // oooooooooooo END - BODY STYLE ooooooooooooooo


  // oooooooooooo BUTTON STYLE ooooooooooooooo
  static const TextStyle button = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 12,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.lightText,
  );
  // oooooooooooo END - BUTTON STYLE ooooooooooooooo


  // oooooooooooo SMALL STYLE ooooooooooooooo
  static const TextStyle small = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 10,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.lightText,
  );
  // oooooooooooo END - SMALL STYLE ooooooooooooooo


  // %%%%%%%%%%%%%%%% END - PROPERTIES %%%%%%%%%%%%%%%%%%%%%
}
