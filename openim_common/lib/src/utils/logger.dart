import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class Logger {
  static Logger? _instance;

  factory Logger() {
    final instance = _instance ??= Logger._();
    instance._setPlatformInfo();

    return instance;
  }

  Logger._();

  void _setPlatformInfo() async {
    final pkg = DeviceInfoPlugin();
    final deviceInfo = await pkg.deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      final apiVersion = deviceInfo.version.sdkInt;

      _header = '[*flutter*Android/$apiVersion]';
    } else if (deviceInfo is IosDeviceInfo) {
      final osVersion = deviceInfo.systemVersion;

      _header = '[*flutter*iOS/$osVersion]';
    }
  }

  String _header = '*flutter*iOS';

  static void print(dynamic text,
      {bool isError = false,
      String? fileName,
      String? functionName,
      String? errorMsg,
      List<dynamic>? keyAndValues,
      bool onlyConsole = false}) {
    final time = DateTime.now().toIso8601String();

    log(
      '$time ${Logger()._header} [Console]: $text, ${keyAndValues != null ? ', $keyAndValues' : ''}, isError [${isError || errorMsg != null}]',
    );
    if (!onlyConsole) {
      OpenIM.iMManager.logs(
        msgs:
            '$time ${Logger()._header} [${functionName ?? ''}]: $text, ${keyAndValues != null ? ', $keyAndValues' : ''}',
        err: errorMsg,
        keyAndValues: keyAndValues ?? [],
      );
    }
  }
}
