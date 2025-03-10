import 'package:flutter/material.dart';

class BarbermateElevatedButtonTheme {
  BarbermateElevatedButtonTheme._();

  //light theme ---------------------------------------------------------------
  static const Color lightThemeColor = Color.fromRGBO(34, 40, 49, 1);
  static const Color lightThemeColorDisabled = Color.fromRGBO(236, 239, 242, 1);
  static const Color lightThemeForeground = Color.fromRGBO(254, 254, 254, 1);
  static const Color ligthThemeForegroundDisabled =
      Color.fromRGBO(130, 151, 174, 1);
  //dark theme ----------------------------------------------------------------
  static const Color darkThemeColor = Color.fromRGBO(254, 254, 254, 1);
  static const Color darkThemeColorDisabled = Color.fromRGBO(130, 151, 174, 1);
  static const Color darkThemeForeground = Color.fromRGBO(34, 40, 49, 1);
  static const Color darkThemeForegroundDisabled =
      Color.fromRGBO(236, 239, 242, 1);

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: lightThemeForeground,
    backgroundColor: lightThemeColor,
    disabledForegroundColor: ligthThemeForegroundDisabled,
    disabledBackgroundColor: lightThemeColorDisabled,
    side: const BorderSide(style: BorderStyle.none),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: lightThemeColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  ));
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: darkThemeForeground,
    backgroundColor: darkThemeColor,
    disabledForegroundColor: darkThemeForegroundDisabled,
    disabledBackgroundColor: darkThemeColorDisabled,
    side: const BorderSide(style: BorderStyle.none),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: darkThemeColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  ));
}
