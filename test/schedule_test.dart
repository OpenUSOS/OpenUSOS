import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/schedule.dart';


class TestSchedule {

  void testGetData() {
    testWidgets("Data should be null if user isn't logged in", (WidgetTester tester) async {
      // Build Schedule
      await tester.pumpWidget(MaterialApp(home: Schedule()));
      // Access the state of Schedule
      ScheduleState state = tester.state(find.byType(Schedule));

      expect(state.subjects, isNull);
    });
  }


  void testDisplay() {
    testWidgets('Schedule should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(MaterialApp(home: Schedule()));

      // Find MyWidget by its type
      expect(find.byType(Schedule), findsOneWidget);
    });
  }
  
  void testLoading() {
    testWidgets('Schedule displays loading indicator while loading',
            (WidgetTester tester) async {
          // Build the widget and trigger a frame
          await tester.pumpWidget(MaterialApp(home: Schedule()));

          // Verify that loading indicator is displayed
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
  }
  
}


void main(){
  final test = TestSchedule();
  test.testGetData();
  test.testDisplay();
  test.testLoading();
  }
