import 'dart:developer';

/// print full log
class Logger {
  // Sample of abstract logging function
  static void print(dynamic text, {bool isError = false}) {
    log('** $text, isError [$isError]', name: 'OpenIM-App');
  }
}
