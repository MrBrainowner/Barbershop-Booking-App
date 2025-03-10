import 'package:flutter/material.dart';

class BarbermateTextTheme {
  BarbermateTextTheme._();

  static const Color blackText = Color.fromRGBO(34, 40, 49, 1);
  static const Color lightText = Color.fromRGBO(254, 254, 254, 1);
  static const Color blackColorOpacity = Color.fromRGBO(34, 40, 49, 0.5);
  static const Color lightColorOpacity = Color.fromRGBO(254, 254, 254, 0.5);

  static TextTheme lightTextTheme = TextTheme(
    // headline ---------------------------------------------------------------------------------------
    headlineLarge: const TextStyle()
        .copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: blackText),
    headlineMedium: const TextStyle()
        .copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: blackText),
    headlineSmall: const TextStyle()
        .copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: blackText),
    // title -------------------------------------------------------------------------------------------
    titleLarge: const TextStyle()
        .copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: blackText),
    titleMedium: const TextStyle()
        .copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: blackText),
    titleSmall: const TextStyle()
        .copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: blackText),
    // body --------------------------------------------------------------------------------------------
    bodyLarge: const TextStyle()
        .copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: blackText),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: blackText),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.w500, color: blackColorOpacity),
    // label -------------------------------------------------------------------------------------------
    labelLarge: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: blackText),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: blackColorOpacity),
  );
  static TextTheme darkTextTheme = TextTheme(
    // headline ---------------------------------------------------------------------------------------
    headlineLarge: const TextStyle()
        .copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: lightText),
    headlineMedium: const TextStyle()
        .copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: lightText),
    headlineSmall: const TextStyle()
        .copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: lightText),
    // title -------------------------------------------------------------------------------------------
    titleLarge: const TextStyle()
        .copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: lightText),
    titleMedium: const TextStyle()
        .copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: lightText),
    titleSmall: const TextStyle()
        .copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: lightText),
    // body --------------------------------------------------------------------------------------------
    bodyLarge: const TextStyle()
        .copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: lightText),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: lightText),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.w500, color: lightColorOpacity),
    // label -------------------------------------------------------------------------------------------
    labelLarge: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: lightText),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: lightColorOpacity),
  );
}
