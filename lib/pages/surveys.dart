import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

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
   final url = Uri.http(UserSession.host, UserSession.basePath,
        {"id": UserSession.sessionId, "query1": "get_surveys"});
    final response = await get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Survey> surveyList = [];
      for (dynamic item in data) {
        List<Question> questionList = [];
        for(dynamic question in item["questions"]){
          questionList.add(Question(
              id: question["id"].toString(),
              number: question["number"].toString(),
              displayText: question["display_text_html"]["pl"],
              allowComment: question["allow_comment"],
              possibleAnswers: question["possible_answers"]
          ));
        }
        surveyList.add(Survey(
          name: item["name"]["pl"],
          id: item["id"].toString(),
          startDate: item["start_date"] != null ? DateTime.parse(item["start_date"]) : DateTime.now(),
          endDate: DateTime.parse(item["end_date"]),
          questions: questionList
        ));

      }
      return surveyList;
    } else {
      throw Exception(
          "Failed to fetch data: HTTP status ${response.statusCode}");
    }
    return [
      Survey(
          name: 'Przykładowa',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          id: 'Tak',
          questions: [
            Question(id: 'Pyt1', number: '1.1', displayText:  'Pytanie Testowe numer 1', allowComment: true, possibleAnswers: []),
            Question(
                id: 'Pyt2',
                number: '1.2',
                displayText: 'Pytanie Testowe numer 2 o bardzo długiej treści w celu przetestowania wyosce długich treści pytań',
                allowComment: false, possibleAnswers: [
              {'id': '1', 'display_text_html': 'Tak'},
              {'id': '2', 'display_text_html': 'Nie'}
            ])
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
                  });
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
  Map<String, TextEditingController> answerControllers = {};
  Map<String, Map<String, dynamic>> answers = {};
  Map<String, Map<String, MaterialColor>> _buttonColors = {};
  late Survey survey;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    for (String controller in answerControllers.keys) {
      answerControllers[controller]?.dispose();
    }
    super.dispose();
  }

  void assignComments(){
    for(Question question in survey.questions){
      if(question.allowComment == true && answerControllers[question.id]?.text != null && answerControllers[question.id]?.text != ""){
        answers[question.id]?["comment"] = answerControllers[question.id]?.text;
      }
    }
  }

  Future<void> _sendSurvey() async {
    assignComments();
    setState(() {
      _isSending = true;
    });

    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'answer_survey',
      "query2": survey.id,
      'query3': jsonEncode(answers)
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Wysyłanie nie powiodło się! HTTP code: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił błąd podczas wysyłania: $e')));
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void initControllersAndColors() {
    if(answerControllers.isNotEmpty || _buttonColors.isNotEmpty){
      return; //we do nothing if values are already initialised,
      // to prevent overwriting them when build is called again
    }
    for (final question in survey.questions) {
      answerControllers[question.id] = TextEditingController();
      _buttonColors[question.id] = {};
      for (final answer in question.possibleAnswers) {
        _buttonColors[question.id]?[answer["id"]] = Colors.grey;
      }
    }
  }

  void changeButtonColor(String questionId, String answerId) {
      this._buttonColors[questionId]?[answerId] =
      this._buttonColors[questionId]?[answerId] == Colors.grey
          ? Colors.blue
          : Colors.grey;
  }

  void initAnswers() {
    if(answers.isNotEmpty){
      return;//if answers already initialised we do nothing to prevent overwriting answers
    }
    for (final question in survey.questions) {
      answers[question.id] = {"answers": [], "comment": null};
    }
  }

  @override
  Widget build(BuildContext context) {
    survey = ModalRoute.of(context)!.settings.arguments as Survey;
    initAnswers();
    initControllersAndColors();
    return Scaffold(
        appBar: USOSBar(title: 'Wypełnij ankietę'),
        bottomNavigationBar: BottomNavBar(),
        drawer: NavBar(),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                child: Text(
                    survey.name,
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(1.5),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: survey.questions.length,
                    itemBuilder: (context, index) {
                      Question question = survey.questions[index];
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
                                child: HtmlWidget(
                                  question.displayText
                                ),
                              ),
                              question.possibleAnswers.length > 0
                                  ? SizedBox(
                                      height:
                                          question.possibleAnswers.length * 50 +
                                              5,
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              question.possibleAnswers.length,
                                          itemBuilder: (context, answerIndex) {
                                            return ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                            _buttonColors[question
                                                                .id]?[question
                                                                    .possibleAnswers[
                                                                answerIndex]["id"]]),
                                                child: HtmlWidget(
                                                    question.possibleAnswers[
                                                            answerIndex]
                                                        ["display_text_html"]["pl"]),
                                                onPressed: () {
                                                    changeButtonColor(
                                                        question.id,
                                                        question.possibleAnswers[
                                                            answerIndex]["id"]);
                                                  if (answers[question.id]
                                                          ?["answers"]
                                                      .contains(question
                                                              .possibleAnswers[
                                                          answerIndex]?["id"])) {
                                                    answers[question.id]
                                                            ?["answers"]
                                                        .remove(question
                                                                .possibleAnswers[
                                                            answerIndex]?["id"]);
                                                  } else {
                                                    answers[question.id]
                                                            ?["answers"]
                                                        .add(question
                                                                .possibleAnswers[
                                                            answerIndex]?["id"]);
                                                  }
                                                  setState(() {

                                                  });
                                                });
                                          }),
                                    )
                                  : Container(),
                              question.allowComment == true
                                  ? TextField(
                                      maxLines: 7,
                                      maxLength: 350,
                                      controller: answerControllers[question.id],
                                      decoration: InputDecoration(
                                          labelText: 'Odpowiedź'),
                                    )
                                  : Container()
                            ],
                          ));
                    }),
              ),
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
                      onPressed: _sendSurvey,
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
  List<Question> questions;

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

class Question {
  String id;
  String number;
  String displayText;
  bool allowComment;
  List<dynamic> possibleAnswers;
  Question({required this.id, required this.number, required this.displayText, required this.allowComment,
     required this.possibleAnswers});
}

