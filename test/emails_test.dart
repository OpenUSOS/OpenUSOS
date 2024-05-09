import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/emails.dart';


class TestEmails {

  void testGetData() {
    testWidgets('Data should be initialized without loging', (WidgetTester tester) async {
      // Build Emails
      await tester.pumpWidget(MaterialApp(home: Emails()));
      // Access the state of Emails
      EmailsState state = tester.state(find.byType(Emails));

      expect(state.user, isNull);
    });
  }


  void testDisplay() {
    testWidgets('Emails should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(MaterialApp(home: Emails()));

      // Find MyWidget by its type
      expect(find.byType(Emails), findsOneWidget);
    });
  }


}


void main(){
  final test = TestEmails();
  test.testGetData();
  test.testDisplay();
}
