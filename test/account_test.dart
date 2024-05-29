import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:open_usos/pages/account.dart';

class TestUser {
  void testGetData() {
    testWidgets('Data should be initialized', (WidgetTester tester) async {
      // Build User
      await tester.pumpWidget(MaterialApp(home: Account()));
      // Access the state of User
      AccountState state = tester.state(find.byType(Account));

      expect(state.user, isNull);
    });
  }

  void testError() {
    testWidgets('Exception User not logged in should be thrown', (WidgetTester tester) async {
      expect(() => tester.pumpWidget(MaterialApp(home: Account())), throwsA(Exception));
    });
  }
}

void main() {
  final test = TestUser();
  test.testGetData();
  test.testError();
}
