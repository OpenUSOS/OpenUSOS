import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_usos/user_session.dart';
import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';

class Term {
  final String termId;
  final Map<String, Course> courses;

  Term({required this.termId, required this.courses});

  factory Term.fromJson(Map<String, dynamic> json) {
    var courseMap = <String, Course>{};
    if (json['courses'] != null) {
      var coursesJson = json['courses'] as List;
      for (var courseJson in coursesJson) {
        var course = Course.fromJson(courseJson);
        courseMap[course.name] = course;
      }
    }
    return Term(termId: json['term_id'], courses: courseMap);
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

    // Sprawdzamy, czy json['name'] jest mapą czy stringiem
    String courseName;
    if (json['name'] is Map) {
      courseName = json['name']['pl'];
    } else {
      courseName = json['name'];
    }
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

    // Sprawdzamy, czy json['name'] i json['description'] są mapą czy stringiem
    String assessmentName;
    String assessmentDescription;
    if (json['name'] is Map) {
      assessmentName = json['name']['pl'];
    } else {
      assessmentName = json['name'];
    }
    if (json['description'] is Map) {
      assessmentDescription = json['description']['pl'];
    } else {
      assessmentDescription = json['description'];
    }
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

  double get totalMaxPoints {
    return exercises.fold(
        0, (sum, exercise) => sum + (exercise.pointsMax ?? 0));
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
    // Sprawdzamy, czy json['name'] i json['description'] są mapą czy stringiem
    String exerciseName;
    String exerciseDescription;
    if (json['name'] is Map) {
      exerciseName = json['name']['pl'];
    } else {
      exerciseName = json['name'];
    }
    if (json['description'] is Map) {
      exerciseDescription = json['description']['pl'];
    } else {
      exerciseDescription = json['description'];
    }
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

// Funkcja do parsowania termów
Map<String, Term> parseTerms(String responseBody) {
  final List<dynamic> parsedList = json.decode(responseBody) as List<dynamic>;
  Map<String, Term> termsMap = {};

  for (var termJson in parsedList) {
    Term term = Term.fromJson(termJson as Map<String, dynamic>);
    termsMap[term.termId] = term;
  }
  return termsMap;
}

// Funkcja do sortowania termów
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
      return bYear.compareTo(aYear); // Sortowanie po roku malejąco
    } else {
      return aTerm.compareTo(bTerm); // Sortowanie po semestrze
    }
  });
  return sortedTerms;
}

class Tests extends StatefulWidget {
  const Tests({super.key});

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            term.termId,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...term.courses.values.map((course) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ExpansionTile(
              title: Text(course.name),
              children: course.assessments.map((assessment) {
                final points = assessment.points ?? assessment.totalPoints;
                final pointsMax =
                    assessment.pointsMax ?? assessment.totalMaxPoints;
                return ExpansionTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(assessment.name)),
                      _buildPointsWidget(points, pointsMax),
                    ],
                  ),
                  subtitle: Text(assessment.description),
                  children: assessment.exercises.map((exercise) {
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(exercise.description),
                      trailing: _buildPointsWidget(
                          exercise.points, exercise.pointsMax),
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

  Widget _buildPointsWidget(double? points, double? pointsMax) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        points != null && pointsMax != null
            ? 'Punkty: ${points}/${pointsMax}'
            : 'Punkty: -/-',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  CourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: ListView.builder(
        itemCount: course.assessments.length,
        itemBuilder: (context, index) {
          final assessment = course.assessments[index];
          final points = assessment.points ?? assessment.totalPoints;
          final pointsMax = assessment.pointsMax ?? assessment.totalMaxPoints;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(child: Text(assessment.name)),
                  _buildPointsWidget(points, pointsMax),
                ],
              ),
              subtitle: Text(assessment.description),
              children: assessment.exercises.map((exercise) {
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description),
                  trailing:
                      _buildPointsWidget(exercise.points, exercise.pointsMax),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsWidget(double? points, double? pointsMax) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        points != null && pointsMax != null
            ? 'Punkty: ${points}/${pointsMax}'
            : 'Punkty: -/-',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
