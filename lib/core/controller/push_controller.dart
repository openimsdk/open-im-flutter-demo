import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:openim_common/openim_common.dart';

class PushController extends GetxController {
  String _platformVersion = 'Unknown';
  String _payloadInfo = 'Null';
  String _notificationState = "";
  String _getClientId = "";
  String _getDeviceToken = "";
  String _onReceivePayload = "";
  String _onReceiveNotificationResponse = "";
  String _onAppLinkPayLoad = "";

  Future<void> _init() async {
    initGetuiSdk();

    if (Platform.isIOS) {
      Getuiflut().startSdk(
        appId: "",
        appKey: "",
        appSecret: "",
      );
    }

    Getuiflut().addEventHandler(
      onReceiveClientId: (String message) async {
        Logger.print("Getui flutter onReceiveClientId: $message");
        _getClientId = "ClientId: $message";
      },
      onReceiveMessageData: (Map<String, dynamic> msg) async {
        Logger.print("Getui flutter onReceiveMessageData: $msg");
        _payloadInfo = msg['payload'];
      },
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        Logger.print("Getui flutter onNotificationMessageArrived: $msg");
        _notificationState = 'Arrived';
      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        Logger.print("Getui flutter onNotificationMessageClicked: $msg");
        _notificationState = 'Clicked';
      },
      onRegisterDeviceToken: (String message) async {
        Logger.print("Getui flutter onRegisterDeviceToken: $message");
        _getDeviceToken = "$message";
      },
      onReceivePayload: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onReceivePayload: $message");
        _onReceivePayload = "$message";
      },
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onReceiveNotificationResponse: $message");
        _onReceiveNotificationResponse = "$message";
      },
      onAppLinkPayload: (String message) async {
        Logger.print("Getui flutter onAppLinkPayload: $message");
        _onAppLinkPayLoad = "$message";
      },
      onPushModeResult: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onPushModeResult: $message");
      },
      onSetTagResult: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onSetTagResult: $message");
      },
      onAliasResult: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onAliasResult: $message");
      },
      onQueryTagResult: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onQueryTagResult: $message");
      },
      onWillPresentNotification: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onWillPresentNotification: $message");
      },
      onOpenSettingsForNotification: (Map<String, dynamic> message) async {
        Logger.print("Getui flutter onOpenSettingsForNotification: $message");
      },
      onTransmitUserMessageReceive: (Map<String, dynamic> event) async {
        Logger.print("Getui flutter onTransmitUserMessageReceive: $event");
      },
      onGrantAuthorization: (String res) async {},
    );
  }

  Future<void> initGetuiSdk() async {
    try {
      Getuiflut.initGetuiSdk;
    } catch (e) {
      e.toString();
    }
  }

  void activityCreate() {
    Getuiflut().onActivityCreate();
  }

  Future<void> getClientId() async {
    String getClientId;
    try {
      getClientId = await Getuiflut.getClientId;
      Logger.print(getClientId);
    } catch (e) {
      Logger.print(e.toString());
    }
  }

  void stopPush() {
    Getuiflut().turnOffPush();
  }

  void startPush() {
    Getuiflut().turnOnPush();
  }

  void login(String uid) {}

  void logout() {}

  void setTag() {
    List test = List.filled(1, 'abc');
    Getuiflut().setTag(test);
  }

  static void setBadge(int badge) {
    Getuiflut().setBadge(badge);
  }

  void setLocalBadge() {
    Getuiflut().setLocalBadge(0);
  }

  static void resetBadge() {
    Getuiflut().resetBadge();
  }

  void setPushMode() {
    Getuiflut().setPushMode(0);
  }

  Future<void> getLaunchNotification() async {
    Map info;
    try {
      info = await Getuiflut.getLaunchNotification;
    } catch (e) {
      Logger.print(e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
