import 'package:flutter/material.dart';

class BarbermateOutlinedButton {
  BarbermateOutlinedButton._();

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

  static final lightThemeOutlinedButton = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    elevation: 0,
    foregroundColor: darkThemeForeground,
    disabledForegroundColor: darkThemeForegroundDisabled,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    side: const BorderSide(
        style: BorderStyle.solid, width: 1, color: lightThemeColor),
    textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: darkThemeForeground),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  ));
  static final darkThemeOutlinedButton = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    elevation: 0,
    foregroundColor: lightThemeForeground,
    disabledForegroundColor: ligthThemeForegroundDisabled,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    side: const BorderSide(
        style: BorderStyle.solid, width: 1, color: darkThemeColor),
    textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: lightThemeForeground),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  ));
}
