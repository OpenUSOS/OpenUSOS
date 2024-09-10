import 'package:flutter/material.dart';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';

class Registrations extends StatefulWidget {
  @override
  State<Registrations> createState() => RegistrationsState();
}

@visibleForTesting
class RegistrationsState extends State<Registrations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'Rejestracje'),
      drawer: NavBar(),
      bottomNavigationBar: BottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Niestety rejestracje jeszcze nie są dostępne w OpenUSOS. \nPrzepraszamy,\n pracujemy nad tym!",
              textScaler: TextScaler.linear(1.5),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
