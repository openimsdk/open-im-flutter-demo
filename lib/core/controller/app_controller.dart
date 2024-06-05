import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:vibration/vibration.dart';

import '../../utils/upgrade_manager.dart';
import 'im_controller.dart';
import 'push_controller.dart';

class AppController extends GetxController with UpgradeManger {
  var isRunningBackground = false;
  var isAppBadgeSupported = false;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {},
  );

  RTCBridge? rtcBridge = PackageBridge.rtcBridge;

  final _ring = 'assets/audio/message_ring.wav';
  final _audioPlayer = AudioPlayer(
      // Handle audio_session events ourselves for the purpose of this demo.
      // handleInterruptions: false,
      // androidApplyAudioAttributes: false,
      // handleAudioSessionActivation: false,
      );

  late BaseDeviceInfo deviceInfo;

  final clientConfigMap = <String, dynamic>{}.obs;

  Future<void> runningBackground(bool run) async {
    Logger.print('-----App running background : $run-------------');

    if (isRunningBackground && !run) {}
    isRunningBackground = run;
    if (!run) {
      _cancelAllNotifications();
    }
  }

  @override
  void onInit() async {
    _requestPermissions();
    _initPlayer();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {},
    );
    isAppBadgeSupported = await FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(im.Message message, {bool showNotification = true}) async {
    if (_isGlobalNotDisturb() ||
            message.attachedInfoElem?.notSenderNotificationPush == true ||
            message.contentType == im.MessageType.typing ||
            message.sendID == OpenIM.iMManager.userID /* ||
        message.contentType! >= 1000*/
        ) return;

    var sourceID = message.sessionType == ConversationType.single ? message.sendID : message.groupID;
    if (sourceID != null && message.sessionType != null) {
      var i = await OpenIM.iMManager.conversationManager.getOneConversation(
        sourceID: sourceID,
        sessionType: message.sessionType!,
      );
      if (i.recvMsgOpt != 0) return;
    }

    if (showNotification) {
      promptSoundOrNotification(message.seq!);
    }
  }

  Future<void> promptSoundOrNotification(int seq) async {
    if (!isRunningBackground) {
      _playMessageSound();
    } else {
      if (Platform.isAndroid) {
        final id = seq;

        const androidPlatformChannelSpecifics = AndroidNotificationDetails('chat', 'OpenIM chat message',
            channelDescription: 'Information from OpenIM', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
        const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(id, 'You have received a new message', 'Message content: .....', platformChannelSpecifics,
            payload: '');
      }
    }
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void showBadge(count) {
    if (isAppBadgeSupported) {
      OpenIM.iMManager.messageManager.setAppBadge(count);

      if (count == 0) {
        removeBadge();
        PushController.resetBadge();
      } else {
        FlutterAppBadger.updateBadgeCount(count);
        PushController.setBadge(count);
      }
    }
  }

  void removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  @override
  void onClose() {
    // backgroundSubject.close();
    closeSubject();
    _audioPlayer.dispose();
    super.onClose();
  }

  Locale? getLocale() {
    var local = Get.locale;
    var index = DataSp.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = const Locale('zh', 'CN');
        break;
      case 2:
        local = const Locale('en', 'US');
        break;
    }
    return local;
  }

  @override
  void onReady() {
    _getDeviceInfo();
    _cancelAllNotifications();
    super.onReady();
  }

  bool _isGlobalNotDisturb() {
    bool isRegistered = Get.isRegistered<IMController>();
    if (isRegistered) {
      var logic = Get.find<IMController>();
      return logic.userInfo.value.globalRecvMsgOpt == 2;
    }
    return false;
  }

  void _initPlayer() {
    _audioPlayer.setAsset(_ring, package: 'openim_common');

    _audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          _stopMessageSound();

          break;
      }
    });
  }

  void _playMessageSound() async {
    bool isRegistered = Get.isRegistered<IMController>();
    bool isAllowVibration = true;
    bool isAllowBeep = true;
    if (isRegistered) {
      var logic = Get.find<IMController>();
      isAllowVibration = logic.userInfo.value.allowVibration == 1;
      isAllowBeep = logic.userInfo.value.allowBeep == 1;
    }

    RingerModeStatus ringerStatus = await SoundMode.ringerModeStatus;

    if (!_audioPlayer.playerState.playing && isAllowBeep && (ringerStatus == RingerModeStatus.normal || ringerStatus == RingerModeStatus.unknown)) {
      _audioPlayer.setAsset(_ring, package: 'openim_common');
      _audioPlayer.setLoopMode(LoopMode.off);
      _audioPlayer.setVolume(1.0);
      _audioPlayer.play();
    }

    if (isAllowVibration &&
        (ringerStatus == RingerModeStatus.normal || ringerStatus == RingerModeStatus.vibrate || ringerStatus == RingerModeStatus.unknown)) {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate();
      }
    }
  }

  void _stopMessageSound() async {
    if (_audioPlayer.playerState.playing) {
      _audioPlayer.stop();
    }
  }

  void _getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfo = await deviceInfoPlugin.deviceInfo;
  }
}
