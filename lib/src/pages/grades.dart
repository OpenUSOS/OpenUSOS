import 'package:flutter/material.dart';
import 'package:open_usos/navbar.dart';

class Grades extends StatefulWidget {
  const Grades({super.key});

  @override
  State<Grades> createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          "OpenUSOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "GRADES",
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );  }
}