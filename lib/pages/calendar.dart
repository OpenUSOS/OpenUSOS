import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};
  TextEditingController _eventController = TextEditingController();

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
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
              if(_eventController.text.isNotEmpty) {
                setState(() {
                  if(_events[_selectedDay] == null) {
                    _events[_selectedDay] = [];
                  }
                  _events[_selectedDay]!.add(_eventController.text);
                  _eventController.clear();
                });
              }
              Navigator.pop(context);
            }
          )
        ]

      ),
      
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
                if(ModalRoute.of(context)!.isCurrent) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                };
              },
              icon: Icon(Icons.home_filled,)
          )
        ]
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2030,12,31),
            availableCalendarFormats: {
              CalendarFormat.month: "Miesiąc",
              CalendarFormat.week: "Tydzień",
              CalendarFormat.twoWeeks: "2 tygodnie",
            },
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
             defaultTextStyle: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
             ) 
            ),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },    
          ),
          SizedBox(
            height: 10.0,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Wydarzenia w wybranym dniu:",
                  style: TextStyle(
                    fontSize: 22.0,
                  ), 
                )
              ),
              _events[_selectedDay] == [] ? Text("Brak") : ListView.builder(
                itemCount: _getEventsForDay(_selectedDay).length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _getEventsForDay(_selectedDay)[index]
                    ),
                  );
                }
              ),
            ],
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