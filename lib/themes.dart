import 'package:flutter/material.dart';

class OpenUSOSThemes {
  static final TextStyle buttonTextStyle = TextStyle(
    fontFamily: 'Lato', 
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
  );

  static final TextStyle listTileTextStyle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
  );

  static final TextStyle appBarTextStyle = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Color.fromARGB(255, 112, 195, 255),
      secondary: Color.fromARGB(255, 69, 162, 255),
      background: Color.fromARGB(255, 255, 255, 255),
    ),
    scaffoldBackgroundColor: Colors.white,
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 231, 189, 255),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        textStyle: buttonTextStyle.copyWith(
          color: Colors.black87,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(2.0, 3.0),
              color: Colors.white60,
              blurRadius: 5.0,
            )
          ]
        )
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.black87,
      iconColor: Colors.black87,
      titleTextStyle: listTileTextStyle.copyWith(color: Colors.blueGrey[800]),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black87, fontSize: 22.0),
      titleSmall: TextStyle(color: Colors.black87, fontSize: 22.0),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 69, 162, 255),
      titleTextStyle: appBarTextStyle.copyWith(color: Colors.black87),
      actionsIconTheme: IconThemeData(
        color: Colors.black87,
      )
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: const Color.fromARGB(255, 181, 181, 181),
      secondary: const Color.fromARGB(255, 73, 73, 73),
      background: const Color.fromARGB(255, 50, 50, 50),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 60, 190, 255),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        textStyle: buttonTextStyle.copyWith(
          color: Colors.white,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(2.0, 3.0),
              color: Colors.black38,
              blurRadius: 5.0,
            )
          ]
        ),
      ),
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 50, 50, 50),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 25, 25, 25),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
      titleTextStyle: listTileTextStyle,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontSize: 22.0),
      titleSmall: TextStyle(color: Colors.white, fontSize: 18.0),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 73, 73, 73),
      titleTextStyle: appBarTextStyle.copyWith(color: Colors.white),
      actionsIconTheme: IconThemeData(
        color: Colors.white70,
      )
    ),
  );
}
