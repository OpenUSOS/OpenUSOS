import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Appointment>> _events = {};
  TextEditingController _eventController = TextEditingController();

  List<Appointment> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Dodaj wydarzenie"),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: 
              TextField(
                controller: _eventController, 
                decoration: InputDecoration(labelText: "Treść wydarzenia")
              ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Anuluj"),
            onPressed: () {
              Navigator.pop(context);
              _eventController.clear();
            }
          ),
          TextButton(
            child: Text("Dodaj"),
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                final appointment = Appointment(
                  startTime: _selectedDay,
                  endTime: _selectedDay.add(Duration(hours: 1)),
                  subject: _eventController.text,
                  color: Colors.blue,
                );

                setState(() {
                  final dayKey = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
                  if (_events[dayKey] == null) {
                    _events[dayKey] = [];
                  }
                  _events[dayKey]!.add(appointment);
                  _eventController.clear();
                });
              }
              Navigator.pop(context);
            }
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kalendarz akademicki",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (ModalRoute.of(context)!.isCurrent) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              };
            },
            icon: Icon(Icons.home_filled)
          )
        ]
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
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
              dataSource: _DataSource(_events),
              onSelectionChanged: (CalendarSelectionDetails details) {
                setState(() {
                  _selectedDay = details.date ?? DateTime.now();
                });
              },
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Wydarzenia w wybranym dniu:",
              style: TextStyle(fontSize: 22.0),
            ),
          ),
          _events[_selectedDay] == null || _events[_selectedDay]!.isEmpty
              ? Text("Brak")
              : Expanded(
                  child: ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay).length,
                    itemBuilder: (context, index) {
                      final appointment = _getEventsForDay(_selectedDay)[index];
                      return ListTile(
                        title: Text(appointment.subject),
                        subtitle: Text(
                          '${appointment.startTime.hour}:${appointment.startTime.minute} - '
                          '${appointment.endTime.hour}:${appointment.endTime.minute}'
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(Map<DateTime, List<Appointment>> source) {
    appointments = source.values.expand((element) => element).toList();
  }
}