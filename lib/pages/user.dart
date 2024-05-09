import 'package:flutter/material.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => UserState();
}

//we annotate it with visibleForTesting to make sure the state class isn't used anywhere else
//we make it public so that it can be tested
@visibleForTesting
class UserState extends State<User> {
  List<Map<String, dynamic>> userData = [];

  void initState() {
    super.initState();
    getData();
  }

  Future setData() async {
    userData = await getData();
    return;
  }

  Future<List<Map<String, dynamic>>> getData() async {
    return [
      {
        'term': '23/24 Z',
        'subject': 'Programowanie',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '23/24 Z',
        'subject': 'Grafika komputerowa',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '23/24 Z',
        'subject': 'Nienawidze programowania 2',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '23/24 Z',
        'subject': 'Wstęp do piekła',
        'grade': 2.0,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '22/23 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '22/23 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '21/22 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
      {
        'term': '21/22 Z',
        'subject': 'Sranie 1',
        'grade': 4.5,
        'professor': 'Rafael Coffee'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
