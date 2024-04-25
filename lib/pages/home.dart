import 'package:flutter/material.dart';

import 'package:open_usos/main.dart';


class Home extends StatefulWidget {
  final App app;
  const Home( this.app, {super.key});

  @override
  State<Home> createState() => HomeState();
}

//we annotate it with visibleForTesting to make sure the state class isn't used anywhere else
//we make it publics so that it can be tested
@visibleForTesting
class HomeState extends State<Home> {

  //build method
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

