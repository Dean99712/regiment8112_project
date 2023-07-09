import 'package:flutter/material.dart';
import 'colors.dart';

class MyThemeData {
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: white,
      secondary: secondaryColor,
      onSecondary: white,
      error: Colors.red.shade400,
      onError: white,
      background: background,
      onBackground: white,
      surface: greyShade700,
      onSurface: white,
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: white,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: white,
      secondary: brownShade300,
      onSecondary: white,
      error: Colors.red.shade400,
      onError: white,
      background: white,
      onBackground: greyShade700,
      surface: greyShade700,
      onSurface: white,
    ),
  );
}
