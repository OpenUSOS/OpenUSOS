import 'package:flutter/material.dart';
import 'package:open_usos/themes.dart';
import 'package:provider/provider.dart';

import 'package:open_usos/pages/home.dart';
import 'package:open_usos/pages/grades.dart';
import 'package:open_usos/settings.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/pages/start_page.dart';



void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: OpenUSOS(),
    ),
  );
}


class OpenUSOS extends StatelessWidget {

  OpenUSOS({super.key}){}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OpenUSOS',
        home: StartPage(),
        themeMode: Settings.currentThemeMode,
        theme: OpenUSOSThemes.lightTheme,
        darkTheme: OpenUSOSThemes.darkTheme,
        routes: {
          '/home': (context) => Home(),
          '/grades': (context) => Grades(),
          '/settings': (context) => Settings(),
          '/login': (context) => FutureBuilder(future: UserSession.startLogin(),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                    child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return LoginPage();
                }
          }),
        }
    );
  }
}