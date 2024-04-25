import 'package:flutter/material.dart';
import 'package:open_usos/navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if(!ModalRoute.of(context)!.isCurrent) {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              };
            },
            icon: Icon(Icons.home_filled,)
          )
        ]
      ),
      body: Center(
        child: Text(
          "HOME PAGE",
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }
}