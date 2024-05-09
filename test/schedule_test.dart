import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/schedule.dart';


class TestGrades {

  void testGetData() {
    testWidgets('Data should be initialized', (WidgetTester tester) async {
      // Build Grades
      await tester.pumpWidget(MaterialApp(home: Grades()));
      // Access the state of Grades
      GradesState state = tester.state(find.byType(Grades));

      expect(state.scheduleData, isNotNull);
      expect(state.scheduleData, isA<List<Map>>());
    });
  }


  void testDisplay() {
    testWidgets('Grades should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(MaterialApp(home: Grades()));

      // Find MyWidget by its type
      expect(find.byType(Grades), findsOneWidget);
    });
  }


  void testDisplayTerms() {
    testWidgets('Grades widget displays correct number of terms', (
        WidgetTester tester) async {
      // Build the Grades widget
      await tester.pumpWidget(MaterialApp(home: Grades()));

      GradesState state = tester.state(find.byType(Grades));

      await state.setData();
      // Verify that the correct number of terms is displayed

      expect(find.byType(ListView, skipOffstage: false),
          findsNWidgets(state.scheduleData.length + 1));
      // list of terms and lists of schedule in each term
    });
  }
}


void main(){
  final test = TestGrades();
  test.testGetData();
  test.testDisplay();
  test.testDisplayTerms();
}
