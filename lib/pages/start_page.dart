import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/user_session.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final List<String> UniversityList = [
    'Uniwersytet Jagielloński',
    'Politechnika Wrocławska',
    'Uniwersytet Warszawski',
    'Chrześcijańska Akademia Teologiczna w Warszawie',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'OpenUSOS'),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Witaj w aplikacji OpenUSOS, która pozwoli ci wygodnie korzystać z konta USOS.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Text(
                  'Aby korzystać z aplikacji zaloguj się kilkając w przycisk poniej.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  style: TextStyle(fontSize: 20),
                  'Wybierz swoją uczelnię',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.0,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: UserSession.currentlySelectedUniversity,
                  onChanged: (String? value) {
                    setState(() {
                      UserSession.currentlySelectedUniversity = value!;
                    });
                  },
                  items: UniversityList.map<DropdownMenuItem<String>>(
                      (String university) {
                    return DropdownMenuItem<String>(
                      value: university,
                      child: Text(university),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Przejdź dalej'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      minimumSize: Size(100, 24)
                    ))
              ])),
    );
  }
}
