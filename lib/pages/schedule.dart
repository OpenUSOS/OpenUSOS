import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
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

  late List<Subject> _subjects;
  late SubjectDataSource _subjectDataSource;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    var random = Random();
    List<Subject> fetchedSubjects = [
      Subject(
          eventName: 'Matematyka',
          from: DateTime.now(),
          to: DateTime.now().add(Duration(hours: 2)),
          background:
              _subjectColorPalette[random.nextInt(_subjectColorPalette.length)],
          isAllDay: false,
          location: "Budynek1"),
      Subject(
          eventName: 'Matematyka',
          from: DateTime.now(),
          to: DateTime.now().add(Duration(days: 1, hours: 2)),
          background:
              _subjectColorPalette[random.nextInt(_subjectColorPalette.length)],
          isAllDay: false,
          location: "Budynek1"),
      Subject(
          eventName: 'Matematyka',
          from: DateTime.now(),
          to: DateTime.now().add(Duration(days: 2, hours: 2)),
          background:
              _subjectColorPalette[random.nextInt(_subjectColorPalette.length)],
          isAllDay: false,
          location: "Budynek1"),
      Subject(
          eventName: 'Matematyka',
          from: DateTime.now(),
          to: DateTime.now().add(Duration(days: 3, hours: 2)),
          background:
              _subjectColorPalette[random.nextInt(_subjectColorPalette.length)],
          isAllDay: false,
          location: "Budynek1"),
      Subject(
          eventName: 'Matematyka',
          from: DateTime.now(),
          to: DateTime.now().add(Duration(days: 4, hours: 2)),
          background:
              _subjectColorPalette[random.nextInt(_subjectColorPalette.length)],
          isAllDay: false,
          location: "Budynek1"),
    ];

    setState(() {
      _subjects = fetchedSubjects;
      _subjectDataSource = SubjectDataSource(_subjects);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plan zajęć'), actions: <Widget>[
        IconButton(
            onPressed: () {
              if (ModalRoute.of(context)!.isCurrent) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              }
              ;
            },
            icon: Icon(
              Icons.home_filled,
            ))
      ]),
      body: SfCalendar(
        view: CalendarView.day,
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: Theme.of(context).brightness == Brightness.light
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
        ),
        dataSource: _subjectDataSource,
        allowViewNavigation: true,
      ),
    );
  }
}

class Subject {
  Subject(
      {required this.eventName,
      required this.from,
      required this.to,
      required this.background,
      required this.isAllDay,
      required this.location});
  String eventName;
  String location;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
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
    return appointments![index].location;
  }
}
