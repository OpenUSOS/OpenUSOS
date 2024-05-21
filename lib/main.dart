import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:open_usos/notifications.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
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
    Notifications notifications = Notifications(context);
    return Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
      return MaterialApp(
          title: 'OpenUSOS',
          themeMode: settingsProvider.themeMode,
          theme: OpenUSOSThemes.lightTheme,
          darkTheme: OpenUSOSThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          supportedLocales: [Locale('pl', '')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('pl', ''),
          home: FutureBuilder( // we try to resume the session, if successful we redirect the user to home page
              future: UserSession.attemptResumeSession(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if(snapshot.hasData == false || snapshot.data == false){
                    return StartPage();
                  }
                  else{
                    return Home();
                  }
                }
              }),
          routes: {
            '/home': (context) => Home(),
            '/grades': (context) => Grades(),
            '/settings': (context) => Settings(),
            '/login': (context) => LoginPage(),
            '/calendar': (context) => Calendar(),
            '/schedule': (context) => Schedule(),
            '/user': (context) => Account(),
            '/emails': (context) => Emails(),
            '/emailSender': (context) => EmailSender(),
            '/emailExpanded':(context) => EmailExpanded(),
            '/exams': (context) => Home(),
            '/start': (context) => StartPage(),
          });
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
