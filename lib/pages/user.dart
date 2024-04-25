import 'package:flutter/material.dart';

import 'package:open_usos/main.dart';


class User extends StatefulWidget {
  final OpenUSOS app;
  const User( this.app, {super.key});

  @override
  State<User> createState() => UserState();
}

//we annotate it with visibleForTesting to make sure the state class isn't used anywhere else
//we make it publics so that it can be tested
@visibleForTesting
class UserState extends State<User> {
  List data = [];

  //we call the superclass constructor and getData to initialize termList
  UserState() : super(){
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
