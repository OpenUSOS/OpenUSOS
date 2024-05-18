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
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color.fromARGB(255, 112, 195, 255),
      secondary: Color.fromARGB(255, 69, 162, 255),
      background: Color.fromARGB(255, 255, 255, 255),
    ),
    scaffoldBackgroundColor: Colors.white,
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.blue.shade900,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white54,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        foregroundColor: Colors.white,
        textStyle: buttonTextStyle.copyWith(
          color: Colors.black,
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.black,
      iconColor: Colors.black,
      titleTextStyle: listTileTextStyle.copyWith(color: Colors.black),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black87, fontSize: 22.0),
      titleSmall: TextStyle(color: Colors.black87, fontSize: 22.0),
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade900,
        titleTextStyle: appBarTextStyle.copyWith(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        )),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Colors.grey.shade300,
      secondary: Colors.grey.shade800,
      background: Colors.grey.shade900,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo.shade400,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        foregroundColor: Colors.white,
        textStyle: buttonTextStyle.copyWith(
          color: Colors.white,
        ),
      ),
    ),
    scaffoldBackgroundColor: Colors.grey.shade800,
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.indigo.shade400,
    ),
    listTileTheme: ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
      titleTextStyle: listTileTextStyle,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontSize: 22.0),
      titleSmall: TextStyle(color: Colors.white, fontSize: 18.0),
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo.shade400,
        titleTextStyle: appBarTextStyle.copyWith(color: Colors.white),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        )),
  );
}
