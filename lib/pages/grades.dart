import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_usos/user_session.dart';
import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';

class Grades extends StatefulWidget {
  const Grades({super.key});

  @override
  State<Grades> createState() => GradesState();
}

class GradesState extends State<Grades> {

  late Future<void> _gradesFuture; //necessary because future builder makes repeated api calls otherwise

  @visibleForTesting
  Map<String, Map<String, List<Grade>>> grades = {};

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

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      Map<String, Map<String, List<Grade>>> gradesByTerm = {};

      for (dynamic item in data) {
        Grade grade = Grade(
          name: item['name'],
          author:
              item['author']['first_name'] + ' ' + item['author']['last_name'],
          date: item['date'],
          term: item['term'],
          value: item['value'],
        );

        gradesByTerm.putIfAbsent(grade.term, () => {});
        var subjectGrades = gradesByTerm[grade.term]!;
        subjectGrades.putIfAbsent(grade.name, () => []);
        subjectGrades[grade.name]!.add(grade);
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

    return Scaffold(
      appBar: USOSBar(title: 'Oceny'),
      bottomNavigationBar: BottomNavBar(),
      drawer: NavBar(),
      body: FutureBuilder(
          future: _gradesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                  itemCount: grades.keys.length,
                  itemBuilder: (context, index) {
                    String term = grades.keys.elementAt(index);
                    Map<String, List<Grade>> subjects = grades[term]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(term,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0))),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: subjects.entries.map((entry) {
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ExpansionTile(
                                title: Text(entry.key,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                children: entry.value.map((grade) {
                                  return ListTile(
                                    title: Text(grade.value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        'Wystawione przez ${grade.author}'),
                                    leading: CircleAvatar(
                                      backgroundColor: grade.value == '2' ||
                                              grade.value == 'NZAL'
                                          ? failed
                                          : passed,
                                      child: Text(grade.value,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }).toList(),
                        )
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
}
