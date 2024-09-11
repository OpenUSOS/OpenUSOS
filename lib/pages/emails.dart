import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/navbar.dart';

class Emails extends StatefulWidget {
  @override
  State<Emails> createState() => EmailsState();
}

@visibleForTesting
class EmailsState extends State<Emails> {
  @visibleForTesting
  List<Email> emailData = [];
  late Future<void>
      _emailsFuture; //future to prevent future builder from sending repeated api calls

  @override
  void initState() {
    super.initState();
    _emailsFuture = _setEmails();
  }

  Future _setEmails() async {
    emailData = await _fetchEmails();
    emailData.sort((a, b) => b.date.compareTo(a.date));
    return;
  }

  Future<List<Email>> _fetchEmails() async {
    final url = Uri.http(UserSession.host, UserSession.basePath,
        {"id": UserSession.sessionId, "query1": "get_emails"});
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
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'Wysłane Maile'),
      bottomNavigationBar: BottomNavBar(),
      drawer: NavBar(),
      body: FutureBuilder(
          future: _emailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView(
                children: [
                  Row(children: [
                    Expanded(
                        child: ElevatedButton(
                            child: Text('Nowa wiadomość'),
                            onPressed: () {
                              Navigator.pushNamed(context, '/emailSender');
                            }))
                  ]),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: emailData.length,
                      itemBuilder: (context, index) {
                        final item = emailData[index];
                        return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: Text(
                                item.subject,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                  'Adresaci: ${item.recipientAddressString()}'),
                              trailing: Text(item.date),
                              onTap: () {
                                Navigator.pushNamed(context, '/emailExpanded',
                                    arguments: item);
                              },
                            ));
                      })
                ],
              );
            }
          }),
    );
  }
}

class EmailSender extends StatefulWidget {
  const EmailSender({super.key});

  @override
  State<EmailSender> createState() => EmailSenderState();
}

@visibleForTesting
class EmailSenderState extends State<EmailSender> {
  @visibleForTesting
  User? user;
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

  Future<void> _sendEmails() async {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: USOSBar(title: 'OpenUSOS mail'),
        bottomNavigationBar: BottomNavBar(),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(children: [
                TextField(
                  controller: _recipientController,
                  decoration: InputDecoration(labelText: 'Odbiorca'),
                ),
                TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(labelText: 'Temat')),
                TextField(
                  minLines: 5,
                  maxLines: null,
                  controller: _bodyController,
                  decoration: InputDecoration(
                    labelText: 'Treść',
                  ),
                  keyboardType: TextInputType.multiline,
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
                        onPressed: _sendEmails,
                        child: Text('Wyślij'),
                      )
              ]),
            )));
  }
}

class EmailExpanded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as Email;
    return Scaffold(
        appBar: USOSBar(title: 'OpenUSOS mail'),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ))),
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Odbiorcy:',
                              softWrap: true,
                              textScaler: TextScaler.linear(0.9),
                            ),
                            Text(
                              '${email.recipientAddressString()}',
                              softWrap: true,
                              textScaler: TextScaler.linear(1.25),
                            ),
                          ],
                        )),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ))),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Temat:',
                              softWrap: true,
                              textScaler: TextScaler.linear(0.9),
                            ),
                            Text(
                              '${email.subject}',
                              softWrap: true,
                              textScaler: TextScaler.linear(1.25),
                              maxLines: 3,
                            ),
                          ],
                        )),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ))),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data wysłania:',
                              textScaler: TextScaler.linear(0.9),
                            ),
                            Text(
                              '${email.date}',
                              textScaler: TextScaler.linear(1.25),
                            ),
                          ],
                        )),
                    Container(
                      height: 8,
                    ),
                    Text(
                      email.contents,
                      textScaler: TextScaler.linear(1.25),
                    ),
                  ]),
            )));
  }
}

class Email {
  String subject;
  String contents;
  String date;
  String id;
  List<dynamic> recipients;

  Email(
      {required this.subject,
      required this.contents,
      required this.date,
      required this.id,
      required this.recipients}) {}

  String recipientAddressString() {
    String result = ' ';

    for (Map<String, dynamic> recipient in recipients) {
      result += recipient['email'] + ", ";
    }

    result = result.substring(0, result.length - 2);
    return result;
  }

  @override
  String toString() {
    return '${this.subject}, ${this.contents}, ${this.date}';
  }
}
