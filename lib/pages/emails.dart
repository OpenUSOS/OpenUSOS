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
  late Future<void> _emailsFuture;

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
                            child: Text('Nowa wiadomośc'),
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
