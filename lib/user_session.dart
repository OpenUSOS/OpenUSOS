import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSession {
  static String? sessionId;
  static const host = 'srv27.mikr.us:20117';
  static const logPath = '/login';
  static const basePath = '/api';

  static Future createSession() async {
    final url = Uri.http(host, logPath);
    var response = await get(url);
    if (response.statusCode == 200) {
      sessionId = response.body;
    }
    else {
      throw Exception('Connecting to server failed');
    }
  }


  static void login() async {
    await createSession();
    final urlURL = Uri.http(host, basePath, {'id': sessionId, 'query1': 'url'});
    var response = await get(urlURL);
    String loginUrl;
    if (response.statusCode == 200) {
      loginUrl = response.body;
    }
    else {
      throw Exception('Getting Login URL failed');
    }
    _launchURL(loginUrl); // opens web browser with the correct link

    throw Exception(post(Uri.parse(loginUrl)));
  }

  static void logout() {
    throw UnimplementedError();
  }


  static _launchURL(String loginUrl) async {
    final url = Uri.parse(loginUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}


