import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan zajęć'),
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
      body: SfCalendar(
        view: CalendarView.day,
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: 
          Theme.of(context).brightness == Brightness.light ? Colors.blue[100] : Colors.indigo[100],
          textStyle: TextStyle(
              fontSize: 25,
            fontStyle: FontStyle.normal,
            letterSpacing: 5,
            color: Colors.white,
            fontWeight: FontWeight.w500
          ),
        ),
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 7,
          endHour: 23,
        ),
        dataSource: _getCalendarDataSource(),
        allowViewNavigation: true,
      ),
    );
  }

  MeetingDataSource _getCalendarDataSource() {
    List<Meeting> meetings = <Meeting>[];

    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(Duration(hours: 2, minutes: 21));
    meetings.add(Meeting('Lekcja 1', startTime, endTime, Colors.blue, false));

    return MeetingDataSource(meetings);
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
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
}