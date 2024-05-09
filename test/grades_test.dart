import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/grades.dart';


class TestGrades {

  void testGetData() {
    testWidgets('Data should be initialized without loging', (WidgetTester tester) async {
      // Build Grades
      await tester.pumpWidget(MaterialApp(home: Grades()));
      // Access the state of Grades
      GradesState state = tester.state(find.byType(Grades));

      expect(state.grades, isNotNull);
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


  void testLoading() {
    testWidgets('Grades displays loading indicator while loading',
            (WidgetTester tester) async {
          // Build the widget and trigger a frame
          await tester.pumpWidget(MaterialApp(home: Grades()));

          // Verify that loading indicator is displayed
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
  }
}


void main(){
  final test = TestGrades();
  test.testGetData();
  test.testDisplay();
  test.testLoading();
}
