import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:open_usos/themes.dart';

class Settings extends StatefulWidget{
  //set of available languages
  final List<String> availableLanguages = ['Polski', 'Polish'];
  //map of available themes, they can be accessed by name
  final Map<String, ThemeData> availableThemes = {"dark": darkTheme};

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //default settings here, if user has other settings set this will be overwritten
  //in _initState setPreferences
  String currentLanguage = 'Polish';
  ThemeData currentTheme = darkTheme;
  bool notificationsOn = false;

  @override
  void initState() {
    super.initState();
    _initPreferences();//we initialize preferences
  }

  void _initPreferences() async{
    // we get preferences and set them using SharedPreferences library
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {//if settings are saved defaults are overwritten, if not nothing happens
      bool? notifications = prefs.getBool('notifications');
      if(notifications != null){
        notificationsOn = notifications;
      }

      String? language = prefs.getString('language');
      if(language != null){
        setLanguage(language);
      }

      String? theme = prefs.getString('theme');
      if(theme != null){
        setTheme(theme);
      }
    });
  }


  // language setter with check if language is available
  void setLanguage(String language) {
    if (widget.availableLanguages.contains(language)) {
      currentLanguage = language;
    } else {
      throw Exception('Language not available');
    }
  }

  //theme setter with check if theme is available
  void setTheme(String themeName) {
    if (widget.availableThemes.containsKey(themeName)) {
      // we check if theme is available and set it
      currentTheme = widget.availableThemes[themeName]!;
    } else {
      throw Exception('Theme not available');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              value: notificationsOn,
              onChanged: (value) {
                setState(() {
                  notificationsOn = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Język'),
              trailing: DropdownButton<String>(
                value: currentLanguage,
                onChanged: (String? value) {
                  setState(() {
                    setLanguage(value!);
                  });
                },
                items: widget.availableLanguages
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
                value: currentLanguage,
                onChanged: (String? value) {
                  setState(() {
                    currentLanguage = value!;
                  });
                },
                items: widget.availableLanguages
                    .map<DropdownMenuItem<String>>((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
              )
          )
        ],
      ),
    );
  }

}
