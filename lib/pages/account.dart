import 'package:flutter/material.dart';

import 'package:open_usos/user_session.dart';
import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => AccountState();
}

@visibleForTesting
class AccountState extends State<Account> {
  @visibleForTesting
  User? user;

  @override
  void initState() {
    super.initState();
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in.');
    }
    user = UserSession.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: USOSBar(title: 'Twoje konto'),
        drawer: NavBar(),
        bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              SizedBox(height: 20.0),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(user!.photoUrl),
                backgroundColor: Colors.transparent,
              ),
              Text('${user!.firstName} ${user!.lastName}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 20.0),
              Text('${user!.emailAddr}',
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
