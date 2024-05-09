import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/appbar.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _UserState();
}

class _UserState extends State<Account> {
  User? _user;

  @override
  void initState() {
    super.initState();
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in.');
    }
    debugPrint('AAaAA chuj');
    _user = UserSession.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: USOSBar(title: 'Twoje konto'),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(height: 20.0),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(_user!.photoUrl),
                backgroundColor: Colors.transparent,
              ),
              Text('${_user!.firstName} ${_user!.lastName}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 20.0),
              Text('${_user!.emailAddr}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  )),
              Row(children: [
                Expanded(
                    child: ElevatedButton(
                        child: Text('Wyloguj się'),
                        onPressed: () {
                          UserSession.logout();
                          Navigator.popUntil(context, (route) => false);
                          Navigator.pushNamed(
                              context, Navigator.defaultRouteName);
                        }))
              ])
            ])));
  }
}
