import 'dart:developer';

class Logger {
  static void print(dynamic text, {bool isError = false}) {
    log('** $text, isError [$isError]', name: 'OpenIM-App');
  }
}
