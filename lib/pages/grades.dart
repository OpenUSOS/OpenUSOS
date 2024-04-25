import 'package:flutter/material.dart';

import 'package:open_usos/main.dart';


class Grades extends StatefulWidget {
  final App app;
  const Grades( this.app, {super.key});

  @override
  State<Grades> createState() => GradesState();
}

//we annotate it with visibleForTesting to make sure the state class isn't used anywhere else
//we make it publics so that it can be tested
@visibleForTesting
class GradesState extends State<Grades> {
  List termList = [];

  //we call the superclass constructor and getData to initialize termList
  GradesState() : super(){
    getData();
  }

  //getting data from api
  void getData() {
    termList = [{"23/24" : 1}, {"24/25" : 2}];
  }

  //build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder( //a list of terms
        itemCount: termList.length,
        itemBuilder: (context, index){
          Map<String, dynamic> currentList = termList[index];
          // Use the current list to build a row
          return ListView.builder( // a list of grades in each term
            itemCount: termList[index].length,
            itemBuilder: (context2, index2) {
              return ListTile( // a grade from a singe class
                  title: Text('List ${index + 1}'),
                  subtitle: Row(
                      children: [
                        for (dynamic item in currentList.entries)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            child: Text('$item'),
                          ),
                      ]
                  )
              );
            }
          );
        },
      ),
    );
  }
}

