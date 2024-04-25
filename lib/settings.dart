import 'package:flutter/material.dart';
import 'package:open_usos/themes.dart';

class Settings {

  Set<String> availableLanguages = {'Polish'};
  Set<ThemeData> availableThemes = {darkTheme};
  String currentLanguage = 'Polish';
  ThemeData currentTheme = darkTheme;
  bool notificationsOn = false;

  Settings(String language, ThemeData theme, bool notifications) {
    notifications = false;
    currentTheme = theme;
    currentLanguage = language;
  }

  void setLanguage(String language) {
    if (availableLanguages.contains(language)) {
      currentLanguage = language;
    } else {
      throw Error();
    }
  }

  void setTheme(ThemeData theme) {
    if (availableThemes.contains(theme)) {
      currentTheme = theme;
    } else {
      throw Error();
    }
  }
}
