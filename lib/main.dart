import 'package:flutter/material.dart';
import 'package:open_usos/src/pages/home.dart';
import 'package:open_usos/src/pages/grades.dart';
void main() {
  runApp(OpenUSOS());
}

class OpenUSOS extends StatelessWidget {
  const OpenUSOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenUSOS',
      home: Home(),
      routes: {
        'home': (context) => Home(),
        '/grades': (context) => Grades(),
        //'/schedule': (context) => Schedule()
      }
    );
  }
}