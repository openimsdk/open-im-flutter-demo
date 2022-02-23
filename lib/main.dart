import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openim_demo/src/app.dart';
import 'package:openim_demo/src/common/config.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (kDebugMode || kProfileMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded(
    () {
      Config.init(() => runApp(EnterpriseChatApp()));
    },
    (Object error, StackTrace stackTrace) {
      print("Error FROM OUT_SIDE FRAMEWORK ");
      print("--------------------------------");
      print("Error :  $error");
      print("StackTrace :  $stackTrace");
      // _reportError(error, stackTrace);
    },
  );
}

/// 使用flutter异常上报
// void main() => FlutterBugly.postCatchedException(() {
//       Config.init(() => runApp(EnterpriseChatApp()));
//     });
