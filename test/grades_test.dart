import 'package:flutter/material.dart';
import 'dart:io';
import 'package:test/test.dart';
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
  late App app;


  void testDisplay() {
    final grades = Grades(app);
    final displayed = grades.display();
    expect(displayed, isA<Widget>());
  }

  void testGetData() {
    final mockConnection = MockUSOSAPIConnection();
    when(mockConnection.get('')).thenAnswer((_) async => {'22/23': {}, '23/24': {}});

    final grades = Grades(app);
    final value = grades.getData();
    expect(value, isA<Map<String, dynamic>>());
    expect(value, equals({'22/23': {}, '23/24': {}}));
    expect(value, equals(grades.data));
  }

  void testDisplayButtons() {
    final grades = Grades(app);
    Widget displayed = grades.display();
    final controlList = [displayed.children];
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
    }
  }
}



