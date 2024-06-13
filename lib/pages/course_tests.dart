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
    debugPrint(json.toString());
    var coursesList = <Course>[];
    if (json['courses'] != null) {
      var coursesJson = json['courses'] as List;
      for (var courseJson in coursesJson) {
        var course = Course.fromJson(courseJson);
        coursesList.add(course);
      }
      coursesList.sort((a, b) => a.name.compareTo(b.name));
    }
    return Term(termId: json['term_id'] ?? '', courses: coursesList);
  }
}

class Course {
  final String name;
  final String nodeId;
  List<Assessment>? assessments;

  Course({required this.name, required this.nodeId, this.assessments});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name']['pl'] ?? '',
      nodeId: json['node_id'].toString(),
    );
  }
}

class Assessment {
  final String id;
  final String name;
  final String description;
  final double? points;
  final double? pointsMax;
  final double? grade;
  final List<String> subnodesIds;
  List<Assessment>? subnodes;

  Assessment({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.pointsMax,
    required this.subnodesIds,
    required this.grade,
    this.subnodes,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    var subnodesIdsList = <String>[];
    if (json['subnodes_ids'] != null) {
      var subnodesJson = json['subnodes_ids'] as List;
      subnodesIdsList = subnodesJson.map((id) => id.toString()).toList();
    }

    double? parsePoints(dynamic value, dynamic grade) {
      if (value == null || value == '-' || value == '') {
        if (grade is num) return grade.toDouble();
        if (grade is String) return double.tryParse(grade);
        return null;
      }
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return Assessment(
      id: json['id'].toString(),
      name: json['name']['pl'] ?? '',
      description: json['description']['pl'] ?? '',
      points: parsePoints(json['points'], json['grade']),
      pointsMax: parsePoints(json['points_max'], null),
      grade: parsePoints(json['grade'], null),
      subnodesIds: subnodesIdsList,
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
  State<CourseTests> createState() => CourseTestsState();
}

@visibleForTesting
class CourseTestsState extends State<CourseTests> {
  @visibleForTesting
  late Future<Map<String, Term>> testsFuture;

  @override
  void initState() {
    super.initState();
    testsFuture = _fetchTestsTop();
  }

  Future<Map<String, Term>> _fetchTestsTop() async {
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in');
    }
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_tests_top',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      return parseTerms(response.body);
    } else {
      throw Exception(
          'Failed to fetch data: HTTP status ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'Sprawdziany'),
      bottomNavigationBar: BottomNavBar(),
      drawer: NavBar(),
      body: FutureBuilder<Map<String, Term>>(
          future: testsFuture,
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
          return CourseCard(course: course);
        }).toList(),
      ],
    );
  }
}

class CourseCard extends StatefulWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late Future<List<Assessment>> _assessmentsFuture;

  @override
  void initState() {
    super.initState();
    _assessmentsFuture = _fetchAssessments();
  }

  Future<List<Assessment>> _fetchAssessments() async {
    if (widget.course.assessments == null) {
      final assessments = await _fetchCourseAssessments(widget.course.nodeId);
      setState(() {
        widget.course.assessments = assessments;
      });
      return assessments;
    } else {
      return widget.course.assessments!;
    }
  }

  Future<List<Assessment>> _fetchCourseAssessments(String nodeId) async {
    List<Assessment> assessments = [];
    var fetchedAssessments = await _fetchAssessmentsForNode(nodeId);
    assessments.addAll(fetchedAssessments);
    return assessments;
  }

  Future<List<Assessment>> _fetchAssessmentsForNode(String nodeId) async {
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_tests_child',
      'query2': nodeId,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var subnodesJson = json.decode(response.body) as List;
      return subnodesJson.map((json) => Assessment.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch data: HTTP status ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ExpansionTile(
        title: Text(
          widget.course.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        children: [
          FutureBuilder<List<Assessment>>(
            future: _assessmentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                var assessments = snapshot.data!;
                return Column(
                  children: assessments.map((assessment) {
                    return AssessmentTile(assessment: assessment);
                  }).toList(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class AssessmentTile extends StatefulWidget {
  final Assessment assessment;

  AssessmentTile({required this.assessment});

  @override
  _AssessmentTileState createState() => _AssessmentTileState();
}

class _AssessmentTileState extends State<AssessmentTile> {
  late Future<List<Assessment>> _subnodesFuture;
  double? calculatedPoints;
  double? calculatedPointsMax;
  bool isCalculating = true;

  @override
  void initState() {
    super.initState();
    _subnodesFuture = _fetchSubnodes();
    _calculatePointsIfNeeded();
  }

  Future<List<Assessment>> _fetchSubnodes() async {
    if (widget.assessment.subnodes != null) {
      return widget.assessment.subnodes!;
    }
    var subnodes = await _fetchAssessmentsForNode(widget.assessment.id);
    setState(() {
      widget.assessment.subnodes = subnodes;
    });
    return subnodes;
  }

  Future<List<Assessment>> _fetchAssessmentsForNode(String nodeId) async {
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_tests_child',
      'query2': nodeId,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var subnodesJson = json.decode(response.body) as List;
      return subnodesJson.map((json) => Assessment.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch data: HTTP status ${response.statusCode}');
    }
  }

  void _calculatePointsIfNeeded() async {
    if (widget.assessment.points == null ||
        widget.assessment.pointsMax == null) {
      var subnodes = await _subnodesFuture;
      double totalPoints = 0.0;
      double totalPointsMax = 0.0;

      for (var subnode in subnodes) {
        if (subnode.points != null) {
          totalPoints += subnode.points!;
        }
        if (subnode.pointsMax != null) {
          totalPointsMax += subnode.pointsMax!;
        }
      }

      setState(() {
        calculatedPoints = totalPoints > 0 ? totalPoints : null;
        calculatedPointsMax = totalPointsMax > 0 ? totalPointsMax : null;
        isCalculating = false;
      });
    } else {
      setState(() {
        isCalculating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final points = widget.assessment.points ?? calculatedPoints;
    final pointsMax = widget.assessment.pointsMax ?? calculatedPointsMax;

    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.assessment.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
          isCalculating
              ? CircularProgressIndicator()
              : _buildPointsWidget(points, pointsMax, context),
        ],
      ),
      subtitle: pointsMax == null
          ? null
          : Text(
              'punkty max: ${pointsMax}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
      children: isCalculating
          ? [Center(child: CircularProgressIndicator())]
          : [
              FutureBuilder<List<Assessment>>(
                future: _subnodesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var subnodes = snapshot.data!;
                    return Column(
                      children: subnodes.map((subnode) {
                        final subnodePoints = subnode.points ?? 0.0;
                        final subnodePointsMax = subnode.pointsMax;
                        return ListTile(
                          title: Text(
                            subnode.name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                          subtitle: subnodePointsMax == null
                              ? null
                              : Text(
                                  'punkty max: ${subnodePointsMax}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w200),
                                ),
                          trailing: _buildPointsWidget(
                              subnodePoints, subnodePointsMax, context),
                        );
                      }).toList(),
                    );
                  }
                },
              )
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
