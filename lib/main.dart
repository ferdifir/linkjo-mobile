import 'package:flutter/material.dart';
import 'package:linkjo/core/app.dart';
import 'package:linkjo/service/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const LinkJoApp());
}
