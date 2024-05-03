import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSession {
  static String? sessionId;
  static const host = 'srv27.mikr.us:20117';
  static const logPath = '/login';
  static const basePath = '/api';
  static String? loginURL;
  static String? accessToken;
  static String? accessTokenSecret;

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


  static Future startLogin() async {
    await createSession();
    final urlURL = Uri.http(host, basePath, {'id': sessionId, 'query1': 'url'});
    var response = await get(urlURL);
    //String loginUrl;
    if (response.statusCode == 200) {
      loginURL = response.body;
    }
    else {
      throw Exception('Getting Login URL failed');
    }
  }

  static Future endLogin(String url) async {
    final receivedUrl = Uri.parse(url);
    final urlLogin = Uri.http(host, basePath,
        {'id': sessionId, 'query1': 'log_in', 'query2': receivedUrl.queryParameters['oauth_verifier']});

  }


  static Future logout() async{
    final logoutURL = Uri.http(host, basePath, {'id': sessionId, 'query1': 'log_out'});
    var response = await get(logoutURL);
    if(response.statusCode == 200){
      accessToken = null;
      accessTokenSecret = null;
      // we need to forget tokens
    }
  }

}

class StartingPage extends StatelessWidget{
  @override
  Widget build(BuildContext buildContext){
    return Scaffold(
      appBar: AppBar(
        title: Text('Logowanie'),
      ),
      body: ElevatedButton(
        child: Text(
          'Zaloguj się'
        ),
        onPressed: () {
          Navigator.pop(buildContext);
          Navigator.pushNamed(buildContext, '/login');
        },
      ),
    );
  }
}


class LoginPage extends StatelessWidget {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
      // Update loading bar.
      },
      onPageStarted: (String url) {UserSession.endLogin(url);},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
        },
    ),
  )
  ..loadRequest(Uri.parse(UserSession.loginURL!));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Logowanie do systemu USOS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  if(ModalRoute.of(context)!.isCurrent) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  };
                },
                icon: Icon(Icons.home_filled,)
            )
          ]
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}