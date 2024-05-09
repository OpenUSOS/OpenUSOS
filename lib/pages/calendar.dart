import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => CalendarState();
}

@visibleForTesting
class CalendarState extends State<Calendar> {
  @visibleForTesting
  DateTime? selectedDay; // Inicjacja jako null
  Map<DateTime, List<Appointment>> _events = {};
  TextEditingController _eventController = TextEditingController();
  TextEditingController _startingTimeController = TextEditingController();
  TextEditingController _endingTimeController = TextEditingController();

  List<Appointment> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _showTimePicker(TextEditingController controller) async {
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
    if (selectedDay == null)
      return; // Nie wykonuj tej funkcji, jeśli _selectedDay jest null

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
                  final dayKey = DateTime(selectedDay!.year,
                      selectedDay!.month, selectedDay!.day);
                  _events[dayKey] = (_events[dayKey] ?? [])..add(appointment);
                  _eventController.clear();
                  _startingTimeController.clear();
                  _endingTimeController.clear();
                });
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text("Kalendarz akademicki",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  if (ModalRoute.of(context)!.isCurrent) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  }
                  ;
                },
                icon: Icon(Icons.home_filled))
          ]),
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
                onPressed: selectedDay != null
                    ? _addEvent
                    : null, // Button is disabled if _selectedDay is null
                child: Text('Dodaj wydarzenie do wybranego dnia'),
              ))
            ],
          ),
          SizedBox(height: 10.0),
          if (selectedDay !=
              null) // Only show this row if _selectedDay is not null
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Wydarzenia w wybranym dniu",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24.0),
                )
              ],
            ),
          if (selectedDay != null &&
              (_events[selectedDay]?.isNotEmpty ??
                  false)) // Only build list if there are events and _selectedDay is not null
            Expanded(
              child: ListView.builder(
                itemCount: _getEventsForDay(selectedDay!).length,
                itemBuilder: (context, index) {
                  final appointment = _getEventsForDay(selectedDay!)[index];
                  return ListTile(
                    title: Text(appointment.subject),
                    subtitle: Text(
                        '${appointment.startTime.hour}:${appointment.startTime.minute} - ${appointment.endTime.hour}:${appointment.endTime.minute}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () => _removeEvent(selectedDay!, index),
                    ),
                  );
                },
              ),
            )
          else if (selectedDay !=
              null) // Show "Brak" if no events and _selectedDay is not null
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
