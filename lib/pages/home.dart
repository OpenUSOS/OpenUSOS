import 'package:flutter/material.dart';

import 'package:open_usos/navbar.dart';
import 'package:open_usos/appbar.dart';

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
      bottomNavigationBar: BottomNavBar(),
      appBar: USOSBar(title: 'Strona główna'),
      body: Center(
        child: Text(
          'TODO',
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
  }
}
