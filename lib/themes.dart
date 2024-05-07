import 'package:flutter/material.dart';

class OpenUSOSThemes {
  static ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.dark().copyWith(
          primary: Colors.blueGrey.shade800,
          primaryContainer: Colors.blueGrey.shade900,
          secondary: Colors.blue.shade800,
          secondaryContainer: Colors.blue.shade900,
          tertiary: Colors.blue.shade500,
          tertiaryContainer: Colors.blue.shade600,
          surface: Colors.grey.shade500, //background colors for different widgets
          background: Colors.grey.shade700
      )
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light().copyWith(
      primary: Colors.blueGrey.shade800,
      primaryContainer: Colors.blueGrey.shade900,
      secondary: Colors.blue.shade800,
      secondaryContainer: Colors.blue.shade900,
      tertiary: Colors.blue.shade500,
      tertiaryContainer: Colors.blue.shade600,
      surface: Colors.grey.shade50, //background colors for different widgets
      background: Colors.grey.shade100
  )
  );
}