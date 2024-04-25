import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:open_usos/usosapi.dart';
import 'package:open_usos/main.dart';
import 'package:open_usos/pages/grades.dart';

class MockUSOSAPIConnection extends Mock implements USOSAPIConnection {
  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    return {'22/23': {}, '23/24': {}};
  }
}

class TestGrades {
  late OpenUSOS app = const OpenUSOS();


  void testGetData() {
    testWidgets('Data should be initialized', (WidgetTester tester) async {
      //mocking api
      const expected = {'22/23': 1, '23/24': 2};
      final mockConnection = MockUSOSAPIConnection();
      when(mockConnection.get('')).thenAnswer((_) async => expected);

      // Build Grades
      await tester.pumpWidget(Grades(app));

      // Trigger the getData method
        // Access the state of MyWidget
      GradesState state = tester.state(find.byType(Grades));
        // Call the getData method
      state.getData();


      expect(state.termList, isA<List<Map>>());
      expect(state.termList, equals([{"23/24" : 1}, {"24/25" : 2}]));
    });
  }


  void testDisplay() {
    testWidgets('Grades should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(Grades(app));

      // Find MyWidget by its type
      expect(find.byType(Grades), findsOneWidget);
    });
  }


  void testDisplayTerms() {
    testWidgets('Grades widget displays correct number of terms', (
        WidgetTester tester) async {
      //mocking api
      const expected = {'22/23': 1, '23/24': 2};
      final mockConnection = MockUSOSAPIConnection();
      when(mockConnection.get('')).thenAnswer((_) async => expected);

      // Build the Grades widget
      await tester.pumpWidget(Grades(app));

      GradesState state = tester.state(find.byType(Grades));
      // Verify that the correct number of terms is displayed
      expect(find.byType(ListView),
          findsNWidgets(state.termList.length + 1));
      // list of terms and lists of grades in each term
    });
  }


  void testDisplayButtons() {
    /*find.byType(TextButton);
    final grades = Grades(app);
    Scaffold displayed = grades.display();
    final controlList = [displayed.body?.children];
    while (controlList.isNotEmpty) {
      final currentControl = controlList.removeLast();
      controlList.addAll(currentControl.controls);
      if (currentControl is ElevatedButton ||
          currentControl is FloatingActionButton ||
          currentControl is TextButton ||
          currentControl is IconButton ||
          currentControl is PopupMenuButton ||
          currentControl is OutlinedButton ||
          currentControl is CupertinoButton) {
        expect(currentControl.onPressed, isNotNull);
        expect(currentControl.onPressed, isA<VoidCallback>());
      }
    }*/
  }
}


void main(){
  final test = TestGrades();
  test.testGetData();
  test.testDisplay();
  test.testDisplayTerms();
  test.testDisplayButtons();
}
