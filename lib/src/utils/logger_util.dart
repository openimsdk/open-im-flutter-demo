import 'dart:developer';

/// print full log
class Logger {
  // Sample of abstract logging function
  static void print(String text, {bool isError = false}) {
    log('** $text, isError [$isError]');
  }
}
