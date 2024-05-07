import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:open_usos/themes.dart';
import 'package:open_usos/user_session.dart';

class SettingsProvider with ChangeNotifier{
  // we set default values here, they are overwritten in _initPreferences
  String currentLanguage = 'Polish';
  bool notificationsOn = false;
  //set of available languages
  final List<String> availableLanguages = ['Polski', 'Polish'];// duplicated values for testing
  //map of available themes, they can be accessed by name
  final Map<String, ThemeMode> availableThemes =
  {'Systemowy': ThemeMode.system, 'Ciemny': ThemeMode.dark, 'Jasny': ThemeMode.light};
  ThemeMode currentThemeMode = ThemeMode.system;



  SettingsProvider(){
    _initPreferences();
  }

  Future _initPreferences() async{
    // we get preferences and set them using SharedPreferences library
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedNotifications = prefs.getBool('notifications');
    if(savedNotifications != null){
      notificationStatus = savedNotifications;
    }

    String? savedLanguage = prefs.getString('language');
    if(savedLanguage != null){
      language = savedLanguage;
    }

    String? savedTheme = prefs.getString('theme');
    if(savedTheme != null){
      theme = savedTheme;
    }
  }

  void saveTheme(String theme) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
  }

  void saveLanguage(String language) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  void saveNotifications(bool notifications) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', notifications);
  }

  ThemeMode get themeMode => currentThemeMode;

  void set theme(String? themeName) {
    if (themeName != null && availableThemes.containsKey(themeName)) {
      // we check if theme is available and set it
      currentThemeMode = availableThemes[themeName]!;
      saveTheme(themeName);
      notifyListeners();
    } else {
      throw Exception('Theme not available');
    }
  }

  String get language => currentLanguage;

  // language setter with check if language is available
  void set language(String? language) {
    if (language != null && availableLanguages.contains(language)) {
      currentLanguage = language;
      saveLanguage(language);
      notifyListeners();
    } else {
      throw Exception('Language not available');
    }
  }

  bool get notificationStatus => notificationsOn;

  // language setter with check if language is available
  void set notificationStatus(bool notifications) {
    notificationsOn = notifications;
    saveNotifications(notifications);
    notifyListeners();
  }

}

class Settings extends StatefulWidget{
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ustawienia",
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
      body: Column(
        children: [
          ListTile(
            title: Text('Powiadomienia'),
            trailing: Switch(
              value: settingsProvider.notificationStatus,
              onChanged: (value) {
                setState(() {
                  settingsProvider.notificationStatus = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Język'),
              trailing: DropdownButton<String>(
                value: settingsProvider.currentLanguage,
                onChanged: (String? value) {
                  setState(() {
                    settingsProvider.language = value;
                  });
                },
                items: settingsProvider.availableLanguages
                    .map<DropdownMenuItem<String>>((String language) {
                return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
                );
              }).toList(),
            )
          ),
          ListTile(
              title: Text('Motyw'),
              trailing: DropdownButton<String>(
                value: settingsProvider.availableThemes.entries.firstWhere((item) =>
                item.value == settingsProvider.currentThemeMode).key,
                onChanged: (String? value) {
                  setState(() {
                    settingsProvider.theme = value;
                  });
                },
                items: settingsProvider.availableThemes.keys
                    .map<DropdownMenuItem<String>>((String theme) {
                  return DropdownMenuItem<String>(
                    value: theme,
                    child: Text(theme),
                  );
                }).toList(),
              )
          ),
          Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text(
                      'Wyloguj'
                    ),
                    onPressed: (){
                      UserSession.logout();
                      Navigator.popUntil(context, (route) => false);
                      Navigator.pushNamed(context, Navigator.defaultRouteName);
                      },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

}
