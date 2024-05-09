import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:open_usos/themes.dart';
import 'package:provider/provider.dart';
import 'package:open_usos/themes.dart';
import 'package:open_usos/pages/calendar.dart';
import 'package:open_usos/pages/home.dart';
import 'package:open_usos/pages/grades.dart';
import 'package:open_usos/settings.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/pages/start_page.dart';
import 'package:open_usos/pages/schedule.dart';
import 'package:open_usos/pages/account.dart';
import 'package:open_usos/pages/emails.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: OpenUSOS(),
    ),
  );
}

class OpenUSOS extends StatelessWidget {
  OpenUSOS({super.key}) {}

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
        home: StartPage(),
        routes: {
          '/home': (context) => Home(),
          '/grades': (context) => Grades(),
          '/settings': (context) => Settings(),
          '/login': (context) => FutureBuilder(
              future: UserSession.startLogin(),
              builder: (context, snapshot) {
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
          '/user': (context) => Account(),
          '/email': (context) => Emails(),
        });
  }
}

class User {
  String firstName;
  String lastName;
  String emailAddr;
  String photoUrl;
  String universityName = "Uniwersytet Jagielloński";

  User(
      {required this.firstName,
      required this.lastName,
      required this.emailAddr,
      required this.photoUrl});

  @override
  String toString() {
    return '${this.firstName}, ${this.lastName}, ${this.emailAddr}, ${this.photoUrl}';
  }
}
