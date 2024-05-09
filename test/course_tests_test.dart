import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/course_tests.dart';



class TestCourseTests {

  void testGetData() {
    testWidgets("Data should be null if user isn't logged in", (WidgetTester tester) async {
      // Build CourseTests
      await tester.pumpWidget(MaterialApp(home: CourseTests()));
      // Access the state of CourseTests
      CourseTestsState state = tester.state(find.byType(CourseTests));

      expect(state.courseTestsData, isNull);
    });
  }


  void testDisplay() {
    testWidgets('CourseTests should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(MaterialApp(home: CourseTests()));

      // Find MyWidget by its type
      expect(find.byType(CourseTests), findsOneWidget);
    });
  }

  void testLoading() {
    testWidgets('CourseTests displays loading indicator while loading',
            (WidgetTester tester) async {
          // Build the widget and trigger a frame
          await tester.pumpWidget(MaterialApp(home: CourseTests()));

          // Verify that loading indicator is displayed
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
  }

}


void main(){
  final test = TestCourseTests();
  test.testGetData();
  test.testDisplay();
  test.testLoading();
}
