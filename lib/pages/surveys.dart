
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/navbar.dart';

class Surveys extends StatefulWidget {
  @override
  State<Surveys> createState() => SurveysState();
}

@visibleForTesting
class SurveysState extends State<Surveys> {
  @visibleForTesting
  List<Survey> surveyData = [];
  late Future<void>
  _SurveysFuture; //future to prevent future builder from sending repeated api calls

  @override
  void initState() {
    super.initState();
    _SurveysFuture = _setSurveys();
  }

  Future _setSurveys() async {
    surveyData = await _fetchSurveys();
    return;
  }

  Future<List<Survey>> _fetchSurveys() async {
   /* final url = Uri.http(UserSession.host, UserSession.basePath,
        {"id": UserSession.sessionId, "query1": "get_Surveys"});
    final response = await get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Email> emailList = [];
      for (dynamic item in data) {
        emailList.add(Email(
            subject: item['subject'] != null ? item['subject'] : " ",
            contents: item['content'] != null ? item['content'] : " ",
            date: item['date'] != null ? item['date'] : " ",
            id: item["id"] != null ? item['id'] : " ",
            recipients: item['to']));
      }
      return emailList;
    } else {
      throw Exception(
          "Failed to fetch data: HTTP status ${response.statusCode}");
    }*/
    return [
      Survey(name: 'Przykładowa', startDate: DateTime.now(), endDate: DateTime.now(), id: 'Tak', questions: [
        {'id': 'Pyt1', 'number': '1.1', 'display_text_html': 'Pytanie Testowe numer 1', 'allow_comment' : true, 'possible_answers': []},
        {'id': 'Pyt2', 'number': '1.2', 'display_text_html': 'Pytanie Testowe numer 2', 'allow_comment' : false,
        'possible_answers': [{'id':'1', 'display_text_html':'Tak'},{'id':'2', 'display_text_html':'Nie'}]}
      ])
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'Ankiety do wypełnienia'),
      bottomNavigationBar: BottomNavBar(),
      drawer: NavBar(),
      body: FutureBuilder(
          future: _SurveysFuture,
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
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: surveyData.length,
                      itemBuilder: (context, index) {
                        final item = surveyData[index];
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
                              subtitle: Text(
                                  'Można wypełnić do: ${item.endDate.toIso8601String()}'),
                              onTap: () {
                                Navigator.pushNamed(context, '/surveyFiller',
                                    arguments: item);
                              },
                            ));
                      }
                      );
            }
          }),
    );
  }
}

class SurveyFiller extends StatefulWidget {
  const SurveyFiller({super.key});

  @override
  State<SurveyFiller> createState() => SurveyFillerState();
}

@visibleForTesting
class SurveyFillerState extends State<SurveyFiller> {
  bool _isSending = false;
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _bodyController.dispose();
    _subjectController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  Future<void> _sendSurveys() async {
    /*
    if (_recipientController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proszę wypełnić wszystkie pola!')));
      return;
    }
    setState(() {
      _isSending = true;
    });
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'send_email',
      'query2': _recipientController.text,
      'query3': _subjectController.text,
      'query4': _bodyController.text
    });

    try {
      final response = await get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        if (data == 'Y') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Wysyłanie powiodło się!')));
        } else if (data == 'N') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Wysyłanie nie powiodło się! Spróbuj ponownie.')));
        }
      } else {
        throw Exception(
            'Something went wrong when sending request, HTTP code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił błąd podczas wysyłania: $e')));
    } finally {
      setState(() {
        _isSending = false;
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    final survey = ModalRoute.of(context)!.settings.arguments as Survey;
    return Scaffold(
        appBar: USOSBar(title: 'Wypełnij ankietę'),
        bottomNavigationBar: BottomNavBar(),
        drawer: NavBar(),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                child: Text(survey.name),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: survey.questions.length,
                  itemBuilder: (context, index){
                    final item = survey.questions[index];
                    return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                item['display_text_html']
                              ),
                            ),
                            ListView.builder(
                                itemCount: item['possible_answers'].length,
                                itemBuilder: (context, answerIndex) {
                                  if (item['allow_comment'] == false) {
                                    return ListTile(
                                        trailing: Text(
                                            item['possible_answers'][answerIndex]['id']),
                                        title: ElevatedButton(
                                          child: Text(
                                              item['possible_answers'][answerIndex]['display_text_html']),
                                          onPressed: () {},
                                        )
                                    );
                                  }

                                  else {
                                    return TextField(
                                      controller: _recipientController,
                                      decoration: InputDecoration(labelText: 'Odpowiedź'),
                                    );
                                  }
                                }
                            )

                          ],
                        )


                    );
                  }),
              SizedBox(height: 20.0),
              _isSending == true
                  ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Wysyłanie...'),
                        CircularProgressIndicator()
                      ]))
                  : ElevatedButton(
                onPressed: _sendSurveys,
                child: Text('Wyślij'),
              )
            ])));
  }
}

class Survey {
  String name;
  DateTime startDate;
  DateTime endDate;
  String id;
  List<dynamic> questions;

  Survey(
      {required this.name,
        required this.startDate,
        required this.endDate,
        required this.id,
        required this.questions}) {}

  @override
  String toString() {
    return '${this.name}, ${this.endDate}';
  }
}
