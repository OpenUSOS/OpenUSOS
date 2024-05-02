import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:open_usos/pages/home.dart';
import 'package:open_usos/pages/grades.dart';
import 'package:open_usos/settings.dart';
import 'package:open_usos/user_session.dart';

void main() {
  runApp(OpenUSOS());
}


class OpenUSOS extends StatelessWidget {

  OpenUSOS({super.key}){
      //UserSession.createSession();
      //sleep(Duration(seconds: 5));
      UserSession.login();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OpenUSOS',
        home: Home(),
        routes: {
          '/home': (context) => Home(),
          '/grades': (context) => Grades(),

          '/settings': (context) => Settings(),
          //'/schedule': (context) => Schedule()

        }
    );
  }
}