import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/surveys.dart';


class TestSurvey {

  void testGetData() {
    testWidgets('Data should be initialized without login', (WidgetTester tester) async {
      // Build Survey
      await tester.pumpWidget(MaterialApp(home: Surveys()));
      // Access the state of Survey
      SurveysState state = tester.state(find.byType(Surveys));

      expect(state.surveyData, isNotNull);
    });
  }


  void testDisplay() {
    testWidgets('Surveys should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(MaterialApp(home: Surveys()));

      // Find MyWidget by its type
      expect(find.byType(Surveys), findsOneWidget);
    });
  }


  void testLoading() {
    testWidgets('Survey displays loading indicator while loading',
            (WidgetTester tester) async {
          // Build the widget and trigger a frame
          await tester.pumpWidget(MaterialApp(home: Surveys()));

          // Verify that loading indicator is displayed
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
  }
}


void main(){
  final test = TestSurvey();
  test.testGetData();
  test.testDisplay();
  test.testLoading();
}
