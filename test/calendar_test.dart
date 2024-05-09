import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class TestCalendar {

  void testGetData() {
    testWidgets('Data should be initialized without loging', (WidgetTester tester) async {
      // Build Calendar
      await tester.pumpWidget(MaterialApp(home: Calendar()));
      // Access the state of Calendar
      CalendarState state = tester.state(find.byType(Calendar));

      expect(state.selectedDay, isNull);
    });
  }


  void testDisplay() {
    testWidgets('Calendar should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(MaterialApp(home: Calendar()));

      // Find MyWidget by its type
      expect(find.byType(Calendar), findsOneWidget);
    });
  }


  void testCalendar() {
    testWidgets('Calendar displays loading indicator while loading',
            (WidgetTester tester) async {
          // Build the widget and trigger a frame
          await tester.pumpWidget(MaterialApp(home: Calendar()));

          // Verify that loading indicator is displayed
          expect(find.byType(SfCalendar), findsOneWidget);
        });
  }
}


void main(){
  final test = TestCalendar();
  test.testGetData();
  test.testDisplay();
  test.testCalendar();
}
