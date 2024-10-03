import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';
import 'package:open_usos/user_session.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => CalendarState();
}

@visibleForTesting
class CalendarState extends State<Calendar> {
  @visibleForTesting
  DateTime? selectedDay;
  Map<DateTime, List<Appointment>> _userEvents = {};
  Map<DateTime, Map<String, dynamic>> _highlightedDays = {};
  Map<String, IconData> _eventIcons = {
    'holidays': Icons.beach_access,
    'public_holidays': Icons.flag,
    'exam_session': Icons.school,
    'break': Icons.free_breakfast,
    'dean': Icons.account_balance,
    'rector': Icons.account_balance_wallet,
  };

  TextEditingController _eventController = TextEditingController();
  TextEditingController _startingTimeController = TextEditingController();
  TextEditingController _endingTimeController = TextEditingController();

  late Future<void> _futureSpecialDays;

  @override
  void initState() {
    super.initState();
    _loadUserEvents();
    _futureSpecialDays = _fetchSpecialDays(
        DateTime.now().subtract(Duration(days: 30)).toString().substring(0, 10),
        DateTime.now().add(Duration(days: 30)).toString().substring(0, 10));
  }

  List<Appointment> _getUserEventsForDay(DateTime day) {
    return _userEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Future<void> _fetchSpecialDays(String startDate, String endDate) async {
    if (UserSession.sessionId == null) {
      throw Exception('sessionId is null, user not logged in');
    }
    final url = Uri.http(UserSession.host, UserSession.basePath, {
      'id': UserSession.sessionId,
      'query1': 'get_events',
      'query2': startDate,
      'query3': endDate,
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        for (var faculty in data) {
          List<dynamic> events = faculty['list'];
          for (var item in events) {
            if ([
              'holidays',
              'public_holidays',
              'exam_session',
              'break',
              'dean',
              'rector'
            ].contains(item['type'])) {
              DateTime startDate = DateTime.parse(item['start_date']);
              DateTime endDate = DateTime.parse(item['end_date']);
              final subject = item['name']['pl'] ?? 'No Title';
              final description = item['is_day_off']
                  ? '$subject - Wolne'
                  : '$subject - Nie wolne';

              for (DateTime date = startDate;
                  date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
                  date = date.add(Duration(days: 1))) {
                final dayKey = DateTime(date.year, date.month, date.day);
                if (!_highlightedDays.containsKey(dayKey)) {
                  _highlightedDays[dayKey] = {
                    'type': item['type'],
                    'description': description,
                    'subject': subject,
                    'is_day_off': item['is_day_off'],
                  };
                }
              }
            }
          }
        }
      });
    } else {
      throw Exception(
          'failed to fetch data: HTTP status ${response.statusCode}');
    }
  }

  void updateCalendar(ViewChangedDetails details) {
    String startDate = details.visibleDates.first.subtract(Duration(days: 31)).toString().substring(0, 10);
    String endDate = details.visibleDates.last.add(Duration(days: 31)).toString().substring(0, 10);

    _fetchSpecialDays(startDate, endDate);
  }

  Future<void> _showTimePicker(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          );
        });
    if (picked != null && selectedDay != null) {
      DateTime pickedTime = DateTime(selectedDay!.year, selectedDay!.month,
          selectedDay!.day, picked.hour, picked.minute);
      controller.text = pickedTime.toIso8601String();
    }
  }

  void _removeEvent(DateTime day, int index) {
    setState(() {
      _userEvents[day]?.removeAt(index);
      if (_userEvents[day]?.isEmpty ?? false) {
        _userEvents.remove(day);
      }
      _saveUserEvents();
    });
  }

  @override
  void dispose() {
    _eventController.dispose();
    _startingTimeController.dispose();
    _endingTimeController.dispose();
    super.dispose();
  }

  void _addEvent() {
    if (selectedDay == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Dodaj wydarzenie"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _eventController,
                decoration: InputDecoration(labelText: "Treść wydarzenia"),
              ),
              TextField(
                controller: _startingTimeController,
                decoration: InputDecoration(labelText: "Czas rozpoczęcia"),
                onTap: () => _showTimePicker(_startingTimeController),
              ),
              TextField(
                controller: _endingTimeController,
                decoration: InputDecoration(labelText: "Czas zakończenia"),
                onTap: () => _showTimePicker(_endingTimeController),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Anuluj"),
            onPressed: () {
              Navigator.pop(context);
              _eventController.clear();
              _startingTimeController.clear();
              _endingTimeController.clear();
            },
          ),
          TextButton(
            child: Text("Dodaj"),
            onPressed: () {
              DateTime startTime = DateTime.parse(_startingTimeController.text);
              DateTime endingTime = DateTime.parse(_endingTimeController.text);
              if (endingTime.isBefore(startTime)) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Błąd"),
                    content: Text(
                        "Czas zakończenia nie może być wcześniejszy niż czas rozpoczęcia."),
                    actions: <Widget>[
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              } else {
                final appointment = Appointment(
                  startTime: startTime,
                  endTime: endingTime,
                  subject: _eventController.text,
                  color: Colors.blue,
                );

                setState(() {
                  final dayKey = DateTime(
                      selectedDay!.year, selectedDay!.month, selectedDay!.day);

                  if (_userEvents[dayKey] != null &&
                      _userEvents[dayKey]!.any((app) =>
                          app.subject == appointment.subject &&
                          app.startTime == appointment.startTime &&
                          app.endTime == appointment.endTime &&
                          app.color == appointment.color)) {
                    return;
                  }

                  _userEvents[dayKey] = (_userEvents[dayKey] ?? [])
                    ..add(appointment);
                  _eventController.clear();
                  _startingTimeController.clear();
                  _endingTimeController.clear();
                  _saveUserEvents();
                });
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> _saveUserEvents() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> stringEvents = {};
    _userEvents.forEach((key, value) {
      stringEvents[key.toIso8601String()] =
          jsonEncode(value.map((e) => _appointmentToJson(e)).toList());
    });
    await prefs.setString('user_events', jsonEncode(stringEvents));
  }

  Future<void> _loadUserEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsString = prefs.getString('user_events');
    if (eventsString != null) {
      final Map<String, dynamic> decodedEvents = jsonDecode(eventsString);
      setState(() {
        _userEvents = decodedEvents.map((key, value) {
          DateTime date = DateTime.parse(key);
          List<Appointment> appointments = (jsonDecode(value) as List)
              .map((e) => _appointmentFromJson(e))
              .toList();
          return MapEntry(date, appointments);
        });
      });
    }
  }

  Map<String, dynamic> _appointmentToJson(Appointment appointment) {
    return {
      'startTime': appointment.startTime.toIso8601String(),
      'endTime': appointment.endTime.toIso8601String(),
      'subject': appointment.subject,
      'color': appointment.color.value,
    };
  }

  Appointment _appointmentFromJson(Map<String, dynamic> json) {
    return Appointment(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      subject: json['subject'] ?? 'No Title',
      color: Color(json['color']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: USOSBar(title: 'Kalendarz'),
      drawer: NavBar(),
      bottomNavigationBar: BottomNavBar(),
      body: FutureBuilder<void>(
        future: _futureSpecialDays,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: <Widget>[
                SfCalendar(
                  firstDayOfWeek: 1,
                  view: CalendarView.month,
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
                        fontWeight: FontWeight.w500),
                  ),
                  dataSource: _DataSource(_userEvents),
                  onViewChanged: updateCalendar,
                  onSelectionChanged: (CalendarSelectionDetails details) {
                    setState(() {
                      selectedDay = details.date;
                    });
                  },
                  monthCellBuilder:
                      (BuildContext context, MonthCellDetails details) {
                    final DateTime day = details.date;
                    bool isHighlighted = _highlightedDays
                        .containsKey(DateTime(day.year, day.month, day.day));
                    Map<String, dynamic>? eventDetails = _highlightedDays[
                        DateTime(day.year, day.month, day.day)];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              day.day.toString(),
                            ),
                          ),
                          if (isHighlighted && eventDetails != null)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  _eventIcons[eventDetails['type']],
                                  size: 16,
                                  color: Colors.purple[300],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                if (selectedDay != null &&
                    _highlightedDays.containsKey(selectedDay))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_highlightedDays[selectedDay]!['subject']} - ${_highlightedDays[selectedDay]!['is_day_off'] ? 'Wolne' : 'Nie wolne'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: selectedDay != null ? _addEvent : null,
                      child: Text('Dodaj wydarzenie do wybranego dnia'),
                    ))
                  ],
                ),
                SizedBox(height: 10.0),
                if (selectedDay != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Twoje wydarzenia w wybranym dniu",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 24.0),
                      )
                    ],
                  ),
                if (selectedDay != null &&
                    (_userEvents[selectedDay]?.isNotEmpty ?? false))
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getUserEventsForDay(selectedDay!).length,
                      itemBuilder: (context, index) {
                        final appointment =
                            _getUserEventsForDay(selectedDay!)[index];
                        return Card(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.blue[900]
                                  : Colors.indigo[300],
                          child: ListTile(
                            title: Text(
                              appointment.subject,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                                '${appointment.startTime.hour}:${appointment.startTime.minute.toString().padRight(2, '0')} - '
                                '${appointment.endTime.hour}:${appointment.endTime.minute.toString().padRight(2, '0')}',
                                style: TextStyle(color: Colors.white)),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_forever,
                                  color: Colors.white),
                              onPressed: () =>
                                  _removeEvent(selectedDay!, index),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else if (selectedDay != null)
                  Expanded(
                    child: Center(
                      child: Text('Brak',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20.0,
                              color: Colors.grey.shade500)),
                    ),
                  )
              ],
            );
          }
        },
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(Map<DateTime, List<Appointment>> source) {
    appointments = source.values.expand((element) => element).toList();
  }
}
