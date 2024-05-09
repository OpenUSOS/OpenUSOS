import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenUSOS'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Witaj w aplikacji OpenUSOS, która pozwoli ci zarządzać swoim kontem USOS.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Aby korzystać z funkcji aplikacji zaloguj się kilkając w przycisk poniej.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('Przejdź do logowania'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                    ))
              ])),
    );
  }
}
