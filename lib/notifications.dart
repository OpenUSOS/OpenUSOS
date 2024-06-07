import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:open_usos/user_session.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzl;
import 'package:background_fetch/background_fetch.dart';

import 'package:open_usos/pages/schedule.dart';
import 'package:open_usos/settings.dart';

/// IMPORTANT - as USOS is only used by universities in Poland, we assume you are in Poland
/// for the sake of the timezone

class Notifications {
  static const int runIntervalDays = 5;
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  final SettingsProvider settingsProvider;

  Notifications(BuildContext context)
      : settingsProvider =
            Provider.of<SettingsProvider>(context, listen: true) {
    tzl.initializeTimeZones(); //necessary for timezones to work properly

    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    plugin.initialize(initializationSettings);

    settingsProvider.addListener(() {
      if (settingsProvider.notificationsOn) {
        _enableNotifications();
      } else {
        _disableNotifications();
      }
    });
  }

  Future<void> scheduleClassNotification(Subject academicActivity, int currentId) async {
    String notificationTimeName = settingsProvider
        .availableNotificationTimes.entries
        .firstWhere(
            (item) => item.value == settingsProvider.currentNotificationTime)
        .key;
    final plannedTime = academicActivity.from
        .subtract(settingsProvider.currentNotificationTime);
    final plannedTimeTZ = //we convert it to timezoned format for proper scheduling
        tz.TZDateTime.from(plannedTime, tz.getLocation('Europe/Warsaw'));
    if (plannedTime.isBefore(DateTime.now())) {
      return; //we don't schedule the notification if it would be in the past
    }
    await plugin.zonedSchedule(
      currentId,
      academicActivity.eventName,
      '${academicActivity.eventName} zaczyna się za ${notificationTimeName} w sali ${academicActivity.roomNumber}',
      plannedTimeTZ,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ClassNotifications',
          'ClassNotifications',
          channelDescription: 'Reminders about upcoming classes',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> getClassesFromDateForDays(String date, String days) async {
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_schedule',
      'query2': date,
      'query3': days,
    });

    final response = await get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Subject> fetchedSubjects = data
          .map((item) => Subject(
                eventName: item['name']['pl'],
                from: DateTime.parse(item['start_time']),
                to: DateTime.parse(item['end_time']),
                buildingName: item['building_name']['pl'],
                roomNumber: item['room_number'],
                background: Colors.black,
                isAllDay: false,
                lang: 'pl',
              ))
          .toList();
      int id = 0;
      for (final subject in fetchedSubjects) {
        scheduleClassNotification(subject, id);
        id++;
      }
    } else {
      throw Exception(
          "failed to fetch data: HTTP status ${response.statusCode}");
    }
  }

  Future<void> run() async {
    await plugin.cancelAll();
    final currentDate = DateTime.now();
      getClassesFromDateForDays(currentDate.toIso8601String().substring(0, 10),
          runIntervalDays.toString());
  }

  Future<void> setRunInBackground() async {
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: runIntervalDays * 60 * 24, //we run it every 5 days
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      await run();
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      //if there is a timeout
      BackgroundFetch.scheduleTask(
          TaskConfig(taskId: 'retryNotifications', delay: 60000));
      BackgroundFetch.finish(taskId);
    });
  }

  void _enableNotifications() async {
    plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    await setRunInBackground();
    await run();
  }

  void _disableNotifications() async {
    await plugin.cancelAll();
    //we set the last notification day to some date in the past, to make sure the pref is always set
    BackgroundFetch.stop();
  }
}
