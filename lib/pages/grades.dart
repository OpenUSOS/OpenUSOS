import 'package:flutter/material.dart';

import 'package:open_usos/view_interface.dart';
import 'package:open_usos/main.dart';

/*class Grades implements ViewInterface {
  final App app;
  Map<dynamic, dynamic> data = {};


  Grades(this.app) {
    data = {};
    throw UnimplementedError();
  }

  @override
  Map<dynamic, dynamic> getData() {
    throw UnimplementedError();
  }

  @override
  display(){
    throw UnimplementedError();
  }
}*/

class Grades extends StatefulWidget {
  const Grades(final app, {super.key});

  @override
  State<Grades> createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  List data = [];


  List getData() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){

        },
      ),
    );
  }
}

