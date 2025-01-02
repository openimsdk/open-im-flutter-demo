import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterOpenimLiveAlert {
  static const MethodChannel _channel = MethodChannel('flutter_openim_live_alert');

  static Future? showLiveAlert({String? title, String? rejectText, String? acceptText}) async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod('showLiveAlert', {
        'title': title,
        'rejectText': rejectText,
        'acceptText': acceptText,
      });
    }
    return null;
  }

  static Future? closeLiveAlert() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod('closeLiveAlert');
    }
    return null;
  }

  static Future? closeLiveAlertAndMoveTaskToFront({
    String? activityName,
    String? packageName,
  }) async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod('closeLiveAlertAndMoveTaskToFront', {
        'activityName': activityName,
        'packageName': packageName,
      });
    }
    return null;
  }

  static buttonEvent({
    Function()? onReject,
    Function()? onAccept,
    String? activityName,
  }) {
    if (Platform.isAndroid) {
      _channel.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'reject':
            onReject?.call();
            closeLiveAlert();
            break;
          case 'accept':
            onAccept?.call();
            closeLiveAlertAndMoveTaskToFront(
              activityName: activityName,
            );
            break;
        }
        return null;
      });
    }
  }
}
