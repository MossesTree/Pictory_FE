import 'package:flutter/material.dart';

abstract final class OnboardingTheme {
  static const Color yellow = Color(0xFFFFD600);
  static const Color black = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF757575);

  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: black,
        onPrimary: Colors.white,
        secondary: yellow,
        onSecondary: black,
        surface: Colors.white,
        onSurface: black,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Color(0xFFBDBDBD),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
