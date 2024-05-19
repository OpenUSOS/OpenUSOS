import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/user_session.dart';
import 'package:open_usos/navbar.dart';

class Schedule extends StatefulWidget {
  @override
  ScheduleState createState() => ScheduleState();
}

@visibleForTesting
class ScheduleState extends State<Schedule> {
  List<Color> _subjectColorPalette = [
    Colors.red.shade400,
    Colors.cyan,
    Colors.pink,
    Colors.blue.shade400,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.deepPurple.shade700,
  ];

  @visibleForTesting
  List<Subject>? subjects;
  SubjectDataSource? _subjectDataSource;
  late Future<void> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = fetchSubjects();
  }

  @visibleForTesting
  Future<void> fetchSubjects() async {
    var random = Random();
    if (UserSession.sessionId == null) {
      throw Exception("sessionId is null, user not logged in.");
    }
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_schedule',
      'query2': '2023-10-01',
      'query3': '365',
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
                background: _subjectColorPalette[
                    random.nextInt(_subjectColorPalette.length - 1)],
                isAllDay: false,
                lang: 'pl',
              ))
          .toList();
      setState(() {
        subjects = fetchedSubjects;
        _subjectDataSource = SubjectDataSource(subjects!);
      });
    } else {
      throw Exception(
          "failed to fetch data: HTTP status ${response.statusCode}");
    }
  }

  Widget buildSubject(
      BuildContext context, CalendarAppointmentDetails details) {
    final Subject subject = details.appointments.first;

    return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
            color: subject.background.withOpacity(1),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Colors.black45,
              )
            ]),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(subject.eventName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12.0)),
              Text(subject.buildingName + ', ' + subject.roomNumber,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      fontSize: 10.0)),
              Text(//added padding for proper minute displaying (without it 10:00 would be displayed as 10:0
                  '${subject.from.hour}:${subject.from.minute.toString().padRight(2, '0')} - '
                      '${subject.to.hour}:${subject.to.minute.toString().padRight(2, '0')}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      fontSize: 10.0)),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: USOSBar(title: 'Plan zajęć'),
      bottomNavigationBar: BottomNavBar(),
      drawer: NavBar(),
      body: FutureBuilder(
          future: _subjectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SfCalendar(
                view: CalendarView.day,
                showDatePickerButton: true,
                headerStyle: CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.blue[100]
                          : Colors.indigo[100],
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 5,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                timeSlotViewSettings: TimeSlotViewSettings(
                  startHour: 7,
                  endHour: 23,
                  nonWorkingDays: <int>[6, 7],
                  minimumAppointmentDuration: Duration(minutes: 45),
                ),
                dataSource: _subjectDataSource,
                allowViewNavigation: true,
                appointmentBuilder: buildSubject,
              );
            }
          }),
    );
  }
}

class Subject {
  Subject({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
    required this.buildingName,
    required this.lang,
    required this.roomNumber,
  });
  String eventName;
  String buildingName;
  String roomNumber;
  String lang;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  //only for testing
  @override
  String toString() {
    return '${this.eventName}';
  }
}

class SubjectDataSource extends CalendarDataSource {
  SubjectDataSource(List<Subject> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getLocation(int index) {
    return appointments![index].buildingName;
  }
}
