import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.grey,
    colorScheme: ColorScheme.dark()
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light()
  );
}