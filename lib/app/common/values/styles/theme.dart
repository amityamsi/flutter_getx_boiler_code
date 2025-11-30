import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';
import '../strings.dart';

class AppTheme {
  static const String _fontFamily = AppStrings.fontFamily;
  // static const String _fontFamily = AppString.fontFamilyRubik;

  static const TextStyle _baseTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontFamily: AppStrings.fontFamily
    // fontFamily: AppString.fontFamilyRubik
  );


  static final ThemeData _primaryTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodySmall: _baseTextStyle.copyWith(fontSize: 10.spMin),
      bodyMedium: _baseTextStyle.copyWith(fontSize: 12.spMin),
      bodyLarge: _baseTextStyle.copyWith(
        fontSize: 14.spMin,
      ),
      displayLarge: _baseTextStyle.copyWith(fontSize: 20.spMin),
      displayMedium: _baseTextStyle.copyWith(fontSize: 18.spMin),
      displaySmall: _baseTextStyle.copyWith(
          fontSize: 16.spMin,
          fontWeight: FontWeight.w400
      ),
      headlineSmall: _baseTextStyle.copyWith(
          fontSize: 22.spMin, fontWeight: FontWeight.w500),
      headlineMedium: _baseTextStyle.copyWith(
          fontSize: 24.spMin, fontWeight: FontWeight.w500),
      headlineLarge: _baseTextStyle.copyWith(
          fontSize: 26.spMin, fontWeight: FontWeight.w500),
    ),
    useMaterial3: false,

    fontFamily: _fontFamily,
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.black),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.black,
      selectionColor: AppColors.black,
      selectionHandleColor: AppColors.white,
    ),
    colorScheme: ColorScheme.light(primary: AppColors.white),
  );

  const AppTheme._(); // Private constructor to prevent instantiation.

  static ThemeData get theme => _primaryTheme;
}
