import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:open_usos/user_session.dart';

class Grades extends StatefulWidget {
  const Grades({super.key});

  @override
  State<Grades> createState() => GradesState();
}

@visibleForTesting
class GradesState extends State<Grades> {

  late Future<void> _gradesFuture; //neccessary because future builder makes repeated api calls otherwise

  @visibleForTesting
  Map<String, List<Grade>> grades = {};

  @override
  void initState() {
    super.initState();
    _gradesFuture = _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    if (UserSession.sessionId == null) {
      throw Exception("sessionId is null, user not logged in.");
    }
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_grades',
    });

    final response = await get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      Map<String, List<Grade>> gradesByTerm = {};

      for (dynamic item in data) {
        Grade grade = Grade(
          name: item['name'],
          author:
              item['author']['first_name'] + ' ' + item['author']['last_name'],
          date: item['date'],
          term: item['term'],
          value: item['value'],
        );

        if (!gradesByTerm.containsKey(grade.term)) {
          gradesByTerm[grade.term] = [];
        }
        gradesByTerm[grade.term]?.add(grade);
      }
      setState(() {
        grades = gradesByTerm;
      });
    } else {
      throw Exception(
          "failed to fetch data: HTTP status ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? failed = Colors.red[800];
    Color? passed = Colors.blue[800];
    //zmienna przechowujaca pogrupowane oceny wzgledem semestrow


    //grupujemy w nowej mapie map
    return Scaffold(
      appBar: AppBar(title: Text('Oceny'), actions: <Widget>[
        IconButton(
            onPressed: () {
              if (ModalRoute.of(context)!.isCurrent) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              }
              ;
            },
            icon: Icon(
              Icons.home_filled,
            ))
      ]),
      body: FutureBuilder(
          future: _gradesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                  itemCount: grades.entries.length,
                  itemBuilder: (context, index) {
                    var term = grades.entries.elementAt(index).key;
                    var gradeDetails = grades.entries.elementAt(index).value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Divider(
                          indent: 10.0,
                          endIndent: 10.0,
                          height: 10.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(term,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0))),
                        Divider(
                          indent: 10.0,
                          endIndent: 10.0,
                          height: 10.0,
                          color: Colors.grey[400],
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: gradeDetails.length,
                            itemBuilder: (context, subIndex) {
                              var item = gradeDetails[subIndex];
                              return Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle:
                                        Text('wystawione przez ${item.author}'),
                                    leading: CircleAvatar(
                                      backgroundColor: item.value == '2' ||
                                              item.value == 'NZAL'
                                          ? failed
                                          : passed,
                                      radius: 30,
                                      child: Text(
                                        item.value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ));
                            })
                      ],
                    );
                  });
            }
          }),
    );
  }
}

class Grade {
  String date;
  String author;
  String value;
  String name;
  String term;

  Grade(
      {required this.date,
      required this.author,
      required this.value,
      required this.name,
      required this.term});

  @override
  String toString() {
    return '${this.name}, ${this.term}, ${this.value}, ${this.author}';
  }
}
