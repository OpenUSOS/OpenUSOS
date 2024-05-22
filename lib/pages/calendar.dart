import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:open_usos/appbar.dart';
import 'package:open_usos/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => CalendarState();
}

@visibleForTesting
class CalendarState extends State<Calendar> {
  @visibleForTesting
  DateTime? selectedDay;
  Map<DateTime, List<Appointment>> _events = {};
  TextEditingController _eventController = TextEditingController();
  TextEditingController _startingTimeController = TextEditingController();
  TextEditingController _endingTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  List<Appointment> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
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
      _events[day]?.removeAt(index);
      if (_events[day]?.isEmpty ?? false) {
        _events.remove(day);
      }
      _saveEvents();
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
                  _events[dayKey] = (_events[dayKey] ?? [])..add(appointment);
                  _eventController.clear();
                  _startingTimeController.clear();
                  _endingTimeController.clear();
                  _saveEvents();
                });
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> stringEvents = {};
    _events.forEach((key, value) {
      stringEvents[key.toIso8601String()] =
          jsonEncode(value.map((e) => _appointmentToJson(e)).toList());
    });
    await prefs.setString('events', jsonEncode(stringEvents));
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsString = prefs.getString('events');
    if (eventsString != null) {
      final Map<String, dynamic> decodedEvents = jsonDecode(eventsString);
      setState(() {
        _events = decodedEvents.map((key, value) {
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
      subject: json['subject'],
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
      body: Column(
        children: <Widget>[
          SfCalendar(
            firstDayOfWeek: 1,
            view: CalendarView.month,
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
            dataSource: _DataSource(_events),
            onSelectionChanged: (CalendarSelectionDetails details) {
              setState(() {
                selectedDay = details.date;
              });
            },
          ),
          SizedBox(height: 20.0),
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
                )
              ],
            ),
          if (selectedDay != null &&
              (_events[selectedDay]?.isNotEmpty ?? false))
            Expanded(
              child: ListView.builder(
                itemCount: _getEventsForDay(selectedDay!).length,
                itemBuilder: (context, index) {
                  final appointment = _getEventsForDay(selectedDay!)[index];
                  return Card(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.blue[900]
                        : Colors.indigo[300],
                    child: ListTile(
                      title: Text(
                        appointment.subject,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                          '${appointment.startTime.hour}:${appointment.startTime.minute} - ${appointment.endTime.hour}:${appointment.endTime.minute}',
                          style: TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.white),
                        onPressed: () => _removeEvent(selectedDay!, index),
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
                        color: Colors.grey.shade400)),
              ),
            )
        ],
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(Map<DateTime, List<Appointment>> source) {
    appointments = source.values.expand((element) => element).toList();
  }
}
