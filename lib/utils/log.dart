import 'package:flutter/foundation.dart';

class Log {
  static void d(dynamic message) {
    if (kDebugMode) {
      print('[DEBUG - ${DateTime.now()}] $message');
    }
  }
}