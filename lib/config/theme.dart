import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 68, 130, 79),
    scaffoldBackgroundColor: const Color.fromARGB(255, 234, 234, 234),
    // cardTheme dihilangkan
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 68, 130, 79),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 68, 130, 79),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
}