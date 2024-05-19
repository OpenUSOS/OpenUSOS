import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';

class SettingsProvider with ChangeNotifier {
  // we set default values here, they are overwritten in _initPreferences
  String currentLanguage = 'Polish';
  bool notificationsOn = false;

  //set of available languages
  final List<String> availableLanguages = [
    'Polski',
    'Polish'
  ]; // duplicated values for testing
  //map of available themes, they can be accessed by name
  final Map<String, ThemeMode> availableThemes = {
    'Systemowy': ThemeMode.system,
    'Ciemny': ThemeMode.dark,
    'Jasny': ThemeMode.light
  };
  ThemeMode currentThemeMode = ThemeMode.system;

  SettingsProvider() {
    _initPreferences();
  }

  Future _initPreferences() async {
    // we get preferences and set them using SharedPreferences library
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedNotifications = prefs.getBool('notifications');
    if (savedNotifications != null) {
      notificationStatus = savedNotifications;
    }

    String? savedLanguage = prefs.getString('language');
    if (savedLanguage != null) {
      language = savedLanguage;
    }

    String? savedTheme = prefs.getString('theme');
    if (savedTheme != null) {
      theme = savedTheme;
    }
  }

  void saveTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
  }

  void saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  void saveNotifications(bool notifications) async {
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

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    return Scaffold(
      appBar: USOSBar(title: 'Ustawienia'),
      bottomNavigationBar: BottomNavBar(),
      drawer: NavBar(),
      body: Column(
        children: [
          ListTile(
            title: Text('Powiadomienia'),
            trailing: Switch(
              value: settingsProvider.notificationStatus,
              onChanged: (value) {
                settingsProvider.notificationStatus = value;
              },
            ),
          ),
          ListTile(
              title: Text('Język'),
              trailing: DropdownButton<String>(
                value: settingsProvider.currentLanguage,
                onChanged: (String? value) {
                  settingsProvider.language = value;
                },
                items: settingsProvider.availableLanguages
                    .map<DropdownMenuItem<String>>((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
              )),
          ListTile(
              title: Text('Motyw'),
              trailing: DropdownButton<String>(
                value: settingsProvider.availableThemes.entries
                    .firstWhere((item) =>
                        item.value == settingsProvider.currentThemeMode)
                    .key,
                onChanged: (String? value) {
                  settingsProvider.theme = value;
                },
                items: settingsProvider.availableThemes.keys
                    .map<DropdownMenuItem<String>>((String theme) {
                  return DropdownMenuItem<String>(
                    value: theme,
                    child: Text(theme),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }
}
