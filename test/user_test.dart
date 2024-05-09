import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/user.dart';


class TestUser {

  void testGetData() {
    testWidgets('Data should be initialized', (WidgetTester tester) async {
      // Build User
      await tester.pumpWidget(MaterialApp(home: User()));
      // Access the state of User
      UserState state = tester.state(find.byType(User));

      expect(state.userData, isNotNull);
      expect(state.userData, isA<List<Map>>());
    });
  }


  void testDisplay() {
    testWidgets('User should be displayed', (WidgetTester tester) async {
      // Build MyWidget
      await tester.pumpWidget(MaterialApp(home: User()));

      // Find MyWidget by its type
      expect(find.byType(User), findsOneWidget);
    });
  }


  void testLoading() {
    testWidgets('User displays loading indicator while loading',
            (WidgetTester tester) async {
          // Build the widget and trigger a frame
          await tester.pumpWidget(MaterialApp(home: User()));

          // Verify that loading indicator is displayed
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
  }
}


void main(){
  final test = TestUser();
  test.testGetData();
  test.testDisplay();
  test.testLoading();
}
