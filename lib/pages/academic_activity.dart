import 'package:flutter/material.dart';

import 'package:open_usos/view_interface.dart';
import 'package:open_usos/main.dart';

class AcademicActivity implements ViewInterface {
  final App app;
  Map<dynamic, dynamic> data = {};


  AcademicActivity(this.app) {
    data = {};
    throw UnimplementedError();
  }

  @override
  Map<dynamic, dynamic> getData() {
    throw UnimplementedError();
  }

  @override
  Scaffold display() {
    throw UnimplementedError();
  }
}

