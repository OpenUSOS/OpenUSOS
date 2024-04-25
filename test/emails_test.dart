import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:open_usos/usosapi.dart';
import 'package:open_usos/main.dart';
import 'package:open_usos/pages/emails.dart';

class MockUSOSAPIConnection extends Mock implements USOSAPIConnection {
  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    return {'22/23': {}, '23/24': {}};
  }
}

class TestEmails {
  late App app = const App();


  void testDisplay() {
    testWidgets('MyWidget should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget((app));

      // Find MyWidget by its type
      expect(find.byType(Emails), findsOneWidget);
    });
  }



  void testGetData() {
    testWidgets('Test data should be initialized', (WidgetTester tester) async {
      //mocking api
      const expected = {'22/23': 1, '23/24': 2};
      final mockConnection = MockUSOSAPIConnection();
      when(mockConnection.get('')).thenAnswer((_) async => expected);

      // Build Emails
      await tester.pumpWidget(Emails(app));

      // Trigger the getData method
      // Access the state of MyWidget
      EmailsState state = tester.state(find.byType(Emails));
      // Call the getData method
      state.getData();


      expect(state.data, isA<List<Map>>());
      expect(state.data, equals([{"23/24" : 1}, {"24/25" : 2}]));
    });
  }



  void testDisplayTerms() {
    testWidgets('Emails widget displays correct number of terms', (
        WidgetTester tester) async {
      //mocking api
      const expected = {'22/23': 1, '23/24': 2};
      final mockConnection = MockUSOSAPIConnection();
      when(mockConnection.get('')).thenAnswer((_) async => expected);

      // Build the Emails widget
      await tester.pumpWidget(Emails(app));

      EmailsState state = tester.state(find.byType(Emails));
      // Verify that the correct number of terms is displayed
      expect(find.byType(ListView),
          findsNWidgets(state.data.length + 1));
      // list of terms and lists of grades in each term
    });
  }


  void testDisplayButtons() {
    /*find.byType(TextButton);
    final grades = Emails(app);
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



