import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/common/config.dart';
import 'package:rxdart/rxdart.dart';

class AppInitView extends StatelessWidget {
  const AppInitView({Key? key, required this.builder}) : super(key: key);
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppInitLogic>(
      init: AppInitLogic(),
      builder: (controller) => FocusDetector(
        onForegroundGained: () => controller.runningBackground(false),
        onForegroundLost: () => controller.runningBackground(true),
        child: ScreenUtilInit(
          designSize: Size(Config.UI_W, Config.UI_H),
          builder: builder,
        ),
      ),
    );
  }
}

class AppInitLogic extends GetxController {
  var isRunningBackground = false;
  var backgroundSubject = PublishSubject<bool>();
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var isAppBadgeSupported = false;

  final initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final initializationSettingsIOS = IOSInitializationSettings(
      // requestAlertPermission: false,
      // requestBadgePermission: false,
      // requestSoundPermission: false,
      onDidReceiveLocalNotification: (
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {});

  void runningBackground(bool run) {
    print('-----App running background : $run-------------');
    isRunningBackground = run;
    backgroundSubject.sink.add(run);
    if (!run) {
      _cancelAllNotifications();
    }
  }

  @override
  void onInit() async {
    // _requestPermissions();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      },
    );
    // _startForegroundService();
    isAppBadgeSupported = await FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(dynamic data) async {
    print('-------------------showNotification-----------------');
    var id = 0;
    var showing = false;
    if (data is im.Message) {
      id = data.seq!;
      // 排除typing消息
      showing = data.contentType != im.MessageType.typing;
    }
    if (isRunningBackground && showing && Platform.isAndroid) {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'chat', 'OpenIM聊天消息',
          channelDescription: '来自OpenIM的信息',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          id, '您收到了一条新消息', '消息内容：.....', platformChannelSpecifics,
          payload: 'item x');
    }
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _startForegroundService() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'pro', 'OpenIM后台进程',
        channelDescription: '保证app能收到信息',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(1, 'OpenIM', '正在后台运行...',
            notificationDetails: androidPlatformChannelSpecifics,
            payload: 'item x');
  }

  Future<void> _stopForegroundService() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.stopForegroundService();
  }

  void showBadge(count) {
    if (isAppBadgeSupported) {
      if (count == 0) {
        removeBadge();
      } else {
        FlutterAppBadger.updateBadgeCount(count);
      }
    }
  }

  void removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  @override
  void onClose() {
    backgroundSubject.close();
    super.onClose();
  }
}
