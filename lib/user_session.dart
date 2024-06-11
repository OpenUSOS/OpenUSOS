import 'dart:convert';

import 'package:open_usos/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';

class UserSession {
  static const host = 'srv27.mikr.us:20117'; //server
  static const logPath = '/login'; // path for login
  static const basePath = '/api'; //path for everything else
  static String?
      loginURL; //static because it needs to be accessed by login page
  static String? sessionId;
  static String? accessToken; //access token for api
  static String? accessTokenSecret; //token secret for api
  static User? user;
  static String currentlySelectedUniversity = 'Uniwersytet Jagielloński';


  static Future<bool> attemptResumeSession() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? session = prefs.getString('sessionId');
    sessionId = session;
      String? token = prefs.getString('accessToken');
    String? secret = prefs.getString('accessTokenSecret');
    accessToken = token;
    accessTokenSecret = secret;
  
    final resume = await resumeSession();
    if (resume == false){
      wipeLocalLoginData();
      return false;
    }
    await getUserData();
    return true;
  }

  static Future<bool> resumeSession() async{
    //resuming session
    final urlResume = Uri.http(host, basePath, {
      'id': sessionId,
      'query1': 'resume',
      'query2': accessToken,
      'query3': accessTokenSecret
    });
    final response = await get(urlResume);
    if(response.statusCode != 200 || response.body != 'Y'){
      return false;
    }
    return true;
  }

  static Future<void> getUserData() async {
    if (UserSession.sessionId == null) {
      throw Exception("sessionId is null, user not logged in.");
    }

    final url = Uri.http(UserSession.host, UserSession.basePath,
        {'id': UserSession.sessionId, 'query1': 'user_info'});

    final response = await get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      User fetchedUser = User(
        firstName: data['first_name'],
        lastName: data['last_name'],
        photoUrl: data['photo_url']['200x200'],
        emailAddr: data['email'],
      );
      user = fetchedUser;
    } else {
      throw Exception(
          'failed to fetch data: HTTP status ${response.statusCode}');
    }
  }

  static Future createSession() async {
    final url = Uri.http(host, logPath, {'query1': currentlySelectedUniversity});
    var response = await get(url);
    if (response.statusCode == 200) {
      sessionId = response.body;
    } else {
      throw Exception('Creating session failed, please check your internet connection');
    }
    return;
  }

  static Future startLogin() async {
    await createSession();
    final urlURL = Uri.http(host, basePath, {'id': sessionId, 'query1': 'url'});
    var response = await get(urlURL);
    if (response.statusCode == 200) {
      loginURL = response.body;
    } else {
      throw Exception(
          'Getting Login URL failed, please check your internet connection and restart the app');
    }
    return;
  }

  static Future endLogin(String url) async {
    final receivedUrl = Uri.parse(url);
    final urlLogin = Uri.http(host, basePath, {
      'id': sessionId,
      'query1': 'log_in',
      'query2': receivedUrl.queryParameters['oauth_verifier']
    });
    final response = await get(urlLogin);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      accessToken = body['AT'];
      accessTokenSecret = body['ATS'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', accessToken!);
      prefs.setString('accessTokenSecret', accessTokenSecret!);
      prefs.setString('sessionId', sessionId!);
    }
    await resumeSession();
    await getUserData();
    return;
  }

  static Future logout() async {
    final logoutURL =
        Uri.http(host, basePath, {'id': sessionId, 'query1': 'log_out'});
    var response = await get(logoutURL);
    if (response.statusCode == 200) {
      await wipeLocalLoginData();
    }
    else{
      throw Exception('Logging out failed, please try again');
    }
  }

  static Future wipeLocalLoginData() async{
    accessToken = null;
    accessTokenSecret = null;
    sessionId = null;
    loginURL = null;
    // we need to forget tokens
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    prefs.remove('accessTokenSecret');
    prefs.remove('sessionId');
  }
}

class LoginPage extends StatelessWidget {

  void endWebView(BuildContext context) {
    Navigator.popUntil(context, (route) => route == '/');
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (url.contains('oauth_verifier')) {
              UserSession.endLogin(url);
              endWebView(context);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
    controller.clearCache();
    controller.clearLocalStorage();
    return Scaffold(
        appBar: USOSBar(title: 'Logowanie do systemu USOS'),
        body: FutureBuilder(
            future: UserSession.startLogin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if(snapshot.connectionState == ConnectionState.done && snapshot.hasError == false){
                if(UserSession.loginURL == null) {
                  throw Exception(
                      'Failed getting login URL from server, please restart the app');
                }
                final loginUrl = Uri.parse(UserSession.loginURL!);
                controller.loadRequest(loginUrl);
                return WebViewWidget(
                  controller: controller..clearCache()..clearLocalStorage(),
                );
              }
              else{
                throw Exception('An error ocurred while starting login');
              }
            }
        )
    );
  }


}

class User {
  String firstName;
  String lastName;
  String emailAddr;
  String photoUrl;
  String universityName = UserSession.currentlySelectedUniversity;

  User(
      {required this.firstName,
      required this.lastName,
      required this.emailAddr,
      required this.photoUrl});

  @override
  String toString() {
    return '${this.firstName}, ${this.lastName}, ${this.emailAddr}, ${this.photoUrl}';
  }
}
