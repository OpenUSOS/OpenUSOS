import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/navbar.dart';

class Emails extends StatefulWidget {
  const Emails({super.key});

  @override
  State<Emails> createState() => EmailsState();
}

@visibleForTesting
class EmailsState extends State<Emails> {
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
        drawer: NavBar(),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(
                controller: _recipientController,
                decoration: InputDecoration(labelText: 'Odbiorca'),
              ),
              TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: 'Temat')),
              TextField(
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
            ])));
  }
}
