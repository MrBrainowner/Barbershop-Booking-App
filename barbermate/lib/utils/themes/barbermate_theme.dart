import 'package:flutter/material.dart';

import 'elevated_button_theme.dart';
import 'outline_button_theme.dart';
import 'text_theme.dart';

class BarbermateTheme {
  BarbermateTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.light(
      surface: Color.fromRGBO(238, 238, 238, 1),
      primary: Color.fromRGBO(34, 40, 49, 1),
      secondary: Color.fromRGBO(57, 62, 70, 1),
      tertiary: Color.fromRGBO(255, 211, 105, 1),
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(238, 238, 238, 1),
    primaryColor: const Color.fromRGBO(34, 40, 49, 1),
    textTheme: BarbermateTextTheme.lightTextTheme,
    elevatedButtonTheme: BarbermateElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: BarbermateOutlinedButton.lightThemeOutlinedButton,
  );
  static ThemeData darktTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.dark(
        surface: Color.fromRGBO(34, 40, 49, 1),
        primary: Color.fromRGBO(238, 238, 238, 1),
        secondary: Color.fromRGBO(57, 62, 70, 1),
        tertiary: Color.fromRGBO(255, 211, 105, 1),
      ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color.fromRGBO(34, 40, 49, 1),
      primaryColor: const Color.fromRGBO(238, 238, 238, 1),
      textTheme: BarbermateTextTheme.darkTextTheme,
      elevatedButtonTheme:
          BarbermateElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: BarbermateOutlinedButton.darkThemeOutlinedButton);
}
