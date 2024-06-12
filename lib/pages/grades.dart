import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_usos/user_session.dart';
import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';


class Grades extends StatefulWidget {
  const Grades({super.key});
  static Map<String, Map<String, List<Grade>>> grades = {};


  static Future setGrades() async{
    final unsortedGrades = await getGrades();
    final sortedGrades = sortGradesByTerm(unsortedGrades);
    Grades.grades = sortedGrades;
  }

  static Future<Map<String, Map<String, List<Grade>>>> getGrades() async{
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in.');
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
            author: item['author']['first_name'] +
                ' ' +
                item['author']['last_name'],
            date: item['date'],
            term: item['term'],
            value: item['value'],
            type: item['class_type']);

        gradesByTerm.putIfAbsent(grade.term, () => {});
        var subjectGrades = gradesByTerm[grade.term]!;
        subjectGrades.putIfAbsent(grade.name, () => []);
        subjectGrades[grade.name]!.add(grade);
      }
      return gradesByTerm;
    } else {
      throw Exception(
          'failed to fetch data: HTTP status ${response.statusCode}');
    }
  }

  static Map<String, Map<String, List<Grade>>> sortGradesByTerm(Map<String, Map<String, List<Grade>>> gradesToSort) {
    var sortedKeys = gradesToSort.keys.toList();

    sortedKeys.sort((a, b) {
      var yearA = int.parse(a.substring(0, 2));
      var yearB = int.parse(b.substring(0, 2));
      var termA = a.substring(5);
      var termB = b.substring(5);
      if (yearA != yearB) {
        return yearB.compareTo(yearA);
      } else if (a.length < b.length) {
        return -1;
      } else if (a.length > b.length) {
        return 1;
      } else if (termA == 'L' && termB == 'Z') {
        return -1;
      } else {
        return 1;
      }
    });

    // rebuilding grades map
    Map<String, Map<String, List<Grade>>> sortedGrades = {};
    for (var key in sortedKeys) {
      sortedGrades[key] = gradesToSort[key]!;
    }
    return sortedGrades;
  }

  @override
  State<Grades> createState() => GradesState();
}

class GradesState extends State<Grades> {
  late Future<void>
      _gradesFuture; //necessary because future builder makes repeated api calls otherwise

  @visibleForTesting
  Map<String, Map<String, List<Grade>>> grades = {};

  @override
  void initState() {
    super.initState();
    _gradesFuture = _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    if(!mapEquals(Grades.grades, {})){
      setState(() {
        grades = Grades.grades;
      });
      return;
    }
    else {
      final newGrades = await Grades.getGrades();
      if (!mapEquals(newGrades, Grades.grades)) {
        setState(() {
          grades = Grades.sortGradesByTerm(newGrades);
        });
        return;
      }
      else{
        return;
      }
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
                                    fontSize: 26.0))),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: subjects.entries.map((entry) {
                            Iterable<ListTile> tiles = entry.value.map((grade) {
                              var type = '';
                              switch (grade.type) {
                                case 'CW':
                                  type = 'Ćwiczenia';
                                case 'LAB':
                                  type = 'Laboratorium';
                                case 'WYK':
                                  type = 'Wykład';
                                case 'LEK':
                                  type = 'Lektorat';
                                case 'WF':
                                  type = 'Wychowanie fizyczne';
                                default:
                                  type = '-';
                              }
                              return ListTile(
                                title: Text(type,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                subtitle: Text(
                                    'Wystawione przez ${grade.author}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
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
                            });
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                children: [
                                  Text(entry.key,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  for (var elem in tiles) elem,
                                ],
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
  String type;

  Grade({
    required this.date,
    required this.author,
    required this.value,
    required this.name,
    required this.term,
    required this.type,
  });
}
