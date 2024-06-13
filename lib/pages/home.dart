import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_usos/navbar.dart';
import 'package:open_usos/appbar.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/pages/schedule.dart';
import 'package:open_usos/pages/news.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @visibleForTesting
  List<Subject>? subjects;
  List<NewsArticle>? news;
  late Future<void> _futureHome;

  @override
  void initState() {
    super.initState();
    _futureHome = fetchHomeComponents();
  }

  @visibleForTesting
  Future<void> fetchHomeComponents() async {
    await fetchSubjects();
    await fetchNews(DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        (DateTime.now().day - 1).toString(), '0', '30');
  }

  @visibleForTesting
  Future<void> fetchNews(
      String startDay, String startIndex, String newsAmount) async {
    if (UserSession.sessionId == null) {
      throw Exception("sessionId is null, user not logged in.");
    }

    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_news',
      'query2': startDay,
      'query3': startIndex,
      'query4': newsAmount,
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<NewsArticle> articles = [];
      for (var item in data['items']) {
        var articleData = item['article'];
        articles.add(NewsArticle.fromJson(articleData));
      }
      setState(() {
        news = articles;
      });
    } else {
      throw Exception(
          "failed to fetch data, HTTP status code: ${response.statusCode}");
    }
  }

  Future<void> fetchSubjects() async {
    if (UserSession.sessionId == null) {
      throw Exception("sessionId is null, user not logged in.");
    }
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_schedule',
      //fetch just for today

      'query2': DateTime.now().year.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().day.toString(),
      'query3': '1',
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Subject> fetchedSubjects = data
          .map((item) => Subject(
                eventName: item['name']['pl'],
                from: DateTime.parse(item['start_time']),
                to: DateTime.parse(item['end_time']),
                buildingName: item['building_name']['pl'],
                roomNumber: item['room_number'],
                background: ScheduleState().getColor(item['name']['pl']!),
                isAllDay: false,
                lang: 'pl',
              ))
          .toList();
      setState(() {
        subjects = fetchedSubjects;
      });
    } else {
      throw Exception(
          "failed to fetch data: HTTP status ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      bottomNavigationBar: BottomNavBar(),
      appBar: USOSBar(title: 'Strona główna'),
      body: FutureBuilder(
          future: _futureHome,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              throw Exception("Error: ${snapshot.error}");
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Cześć ${UserSession.user!.firstName}!',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                offset: Offset(2.0, 2.0),
                                color: Colors.grey.shade600,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (subjects != null) ...[
                        Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            color: Colors.grey.shade400),
                        Text(
                          'Twoje zajęcia na dziś',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.grey.shade300,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        subjects!.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0),
                                child: Text(
                                  'Brak zajęć - wolne',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: subjects!.length,
                                itemBuilder: (context, index) {
                                  final subject = subjects![index];
                                  return Card(
                                    color: ScheduleState()
                                        .getColor(subject.eventName),
                                    child: ListTile(
                                      title: Text(subject.eventName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                          '${subject.from.hour}:${subject.from.minute.toString().padLeft(2, '0')} - '
                                          '${subject.to.hour}:${subject.to.minute.toString().padLeft(2, '0')}\n'
                                          'Budynek: ${subject.buildingName}, Sala: ${subject.roomNumber}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300)),
                                    ),
                                    elevation: 8.0,
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                  );
                                },
                              ),
                      ],
                      if (news != null) ...[
                        Divider(
                            indent: 10.0,
                            endIndent: 10.0,
                            color: Colors.grey.shade400),
                        Text(
                          'Nadchodzące wydarzenia',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.grey.shade300,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        news!.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0),
                                child: Text(
                                  'Brak nadchodzących wydarzeń',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: news!.length,
                                itemBuilder: (context, index) {
                                  return NewsArticleWidget(
                                      article: news![index]);
                                },
                              ),
                      ],
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
