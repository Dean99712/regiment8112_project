import 'package:flutter/material.dart';
import 'colors.dart';

class MyThemeData {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    // scaffoldBackgroundColor: backgroundColorDark,
    // primaryColor: primaryColor,
    // colorScheme: ColorScheme.highContrastDark()
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: white,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.highContrastLight()
  );
}