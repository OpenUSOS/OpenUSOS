import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:open_usos/themes.dart';
import 'package:open_usos/pages/calendar.dart';
import 'package:open_usos/pages/home.dart';
import 'package:open_usos/pages/grades.dart';
import 'package:open_usos/settings.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/pages/start_page.dart';
import 'package:open_usos/pages/schedule.dart';



void main() {
  runApp(OpenUSOS());
}


class OpenUSOS extends StatelessWidget {

  OpenUSOS({super.key}){}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OpenUSOS', 
        themeMode: ThemeMode.system,
        theme: OpenUSOSThemes.darkTheme,
        darkTheme: OpenUSOSThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        supportedLocales: [Locale('pl', '')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('pl', ''),
        home: Home(),
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
          '/calendar': (context) => Calendar(),
          '/schedule': (context) => Schedule(),
        }
    );
  }
}