import 'package:flutter/material.dart';

import 'package:open_usos/main.dart';


class AcademicActivity extends StatefulWidget {
  final App app;
  const AcademicActivity( this.app, {super.key});

  @override
  State<AcademicActivity> createState() => AcademicActivityState();
}

//we annotate it with visibleForTesting to make sure the state class isn't used anywhere else
//we make it publics so that it can be tested
@visibleForTesting
class AcademicActivityState extends State<AcademicActivity> {
  List data = [];

  //we call the superclass constructor and getData to initialize termList
  AcademicActivityState() : super(){
    getData();
  }

  //getting data from api
  void getData() {
    data = [{"23/24" : 1}, {"24/25" : 2}];
  }

  //build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          Map<String, dynamic> currentList = data[index];
          // Use the current list to build a row
          return Row();
        },
      ),
    );
  }
}

