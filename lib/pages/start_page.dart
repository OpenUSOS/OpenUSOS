import 'package:flutter/material.dart';

class StartPage extends StatelessWidget{
  @override
  Widget build(BuildContext buildContext){
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
                  'Welcome to the OpenUSOS app for managing your university account.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height : 10.0,
                ),
                Text(
                  'In order to use the app, please log in using your university account credentials.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(buildContext);
                      Navigator.pushNamed(buildContext, '/login');
                    },
                    child: Text(
                        'Go to login'
                    )
                )
              ]
          )
      ),
    );
  }
}