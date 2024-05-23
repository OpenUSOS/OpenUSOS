import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_usos/user_session.dart';
import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';

class Term {
  final String termId;
  final List<Course> courses;

  Term({required this.termId, required this.courses});

  factory Term.fromJson(Map<String, dynamic> json) {
    var coursesList = <Course>[];
    if (json['courses'] != null) {
      var coursesJson = json['courses'] as List;
      for (var courseJson in coursesJson) {
        var course = Course.fromJson(courseJson);
        coursesList.add(course);
      }
      // Sort the courses alphabetically by name
      coursesList.sort((a, b) => a.name.compareTo(b.name));
    }
    return Term(termId: json['term_id'], courses: coursesList);
  }
}

class Course {
  final String name;
  final List<Assessment> assessments;

  Course({required this.name, required this.assessments});

  factory Course.fromJson(Map<String, dynamic> json) {
    var assessmentList = <Assessment>[];
    if (json['tests'] != null) {
      var testsJson = json['tests'] as List;
      for (var testJson in testsJson) {
        var assessment = Assessment.fromJson(testJson);
        assessmentList.add(assessment);
      }
    }

    String courseName = json['name']['pl'];
    return Course(name: courseName, assessments: assessmentList);
  }
}

class Assessment {
  final String name;
  final String description;
  final double? points;
  final double? pointsMax;
  final List<Exercise> exercises;

  Assessment(
      {required this.name,
      required this.description,
      required this.points,
      required this.pointsMax,
      required this.exercises});

  factory Assessment.fromJson(Map<String, dynamic> json) {
    var exerciseList = <Exercise>[];
    if (json['exercises'] != null) {
      var exercisesJson = json['exercises'] as List;
      for (var exerciseJson in exercisesJson) {
        var exercise = Exercise.fromJson(exerciseJson);
        exerciseList.add(exercise);
      }
    }

    String assessmentName = json['name']['pl'];
    String assessmentDescription = json['description']['pl'];

    return Assessment(
      name: assessmentName,
      description: assessmentDescription,
      points:
          json['points'] != null ? (json['points'] as num).toDouble() : null,
      pointsMax: json['points_max'] != null
          ? (json['points_max'] as num).toDouble()
          : null,
      exercises: exerciseList,
    );
  }

  double get totalPoints {
    return exercises.fold(0, (sum, exercise) => sum + (exercise.points ?? 0));
  }
}

class Exercise {
  final String name;
  final String description;
  final double? points;
  final double? pointsMax;

  Exercise(
      {required this.name,
      required this.description,
      required this.points,
      required this.pointsMax});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    String exerciseName = json['name']['pl'];
    String exerciseDescription = json['description']['pl'];
    debugPrint(json.toString());
    return Exercise(
      name: exerciseName,
      description: exerciseDescription,
      points:
          json['points'] != null ? (json['points'] as num).toDouble() : null,
      pointsMax: json['points_max'] != null
          ? (json['points_max'] as num).toDouble()
          : null,
    );
  }
}

Map<String, Term> parseTerms(String responseBody) {
  final List<dynamic> parsedList = json.decode(responseBody) as List<dynamic>;
  Map<String, Term> termsMap = {};

  for (var termJson in parsedList) {
    Term term = Term.fromJson(termJson as Map<String, dynamic>);
    termsMap[term.termId] = term;
  }
  return termsMap;
}

List<String> sortTerms(Map<String, Term> termsMap) {
  var sortedTerms = termsMap.keys.toList();
  sortedTerms.sort((a, b) {
    var aParts = a.split('/');
    var bParts = b.split('/');
    var aYear = int.parse(aParts[0]);
    var bYear = int.parse(bParts[0]);
    var aTerm = aParts[1];
    var bTerm = bParts[1];
    if (aYear != bYear) {
      return bYear.compareTo(aYear);
    } else {
      return aTerm.compareTo(bTerm);
    }
  });
  return sortedTerms;
}

class CourseTests extends StatefulWidget {
  const CourseTests({super.key});

  @override
  State<CourseTests> createState() => _TestsState();
}

class _TestsState extends State<CourseTests> {
  late Future<Map<String, Term>> _testsFuture;

  @override
  void initState() {
    super.initState();
    _testsFuture = _fetchTests();
  }

  Future<Map<String, Term>> _fetchTests() async {
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in');
    }
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_tests',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return parseTerms(response.body);
    } else {
      throw Exception(
          'failed to fetch data: HTTP status ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'Sprawdziany'),
      bottomNavigationBar: BottomNavBar(),
      drawer: NavBar(),
      body: FutureBuilder<Map<String, Term>>(
          future: _testsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final termsMap = snapshot.data!;
              final sortedTerms = sortTerms(termsMap);
              return ListView.builder(
                itemCount: sortedTerms.length,
                itemBuilder: (context, index) {
                  String termId = sortedTerms[index];
                  return TermWidget(term: termsMap[termId]!);
                },
              );
            }
          }),
    );
  }
}

class TermWidget extends StatelessWidget {
  final Term term;

  TermWidget({required this.term});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Divider(),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            term.termId,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
        ...term.courses.map((course) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ExpansionTile(
              title: Text(
                course.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              children: course.assessments.map((assessment) {
                final points = assessment.points ?? assessment.totalPoints;
                final pointsMax = assessment.pointsMax;
                return ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          assessment.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                      _buildPointsWidget(points, pointsMax, context),
                    ],
                  ),
                  subtitle: assessment.pointsMax == null
                      ? null
                      : Text(
                          'punkty max: ${assessment.pointsMax}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                  children: assessment.exercises.map((exercise) {
                    return ListTile(
                      title: Text(
                        exercise.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                      subtitle: Text(
                        'punkty max: ${exercise.pointsMax ?? '-'}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w200),
                      ),
                      trailing: _buildPointsWidget(
                          exercise.points, exercise.pointsMax, context),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPointsWidget(double? points, double? pointsMax, context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.blue[900]
            : Colors.indigo[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(points == null ? '0.0' : '${points}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
