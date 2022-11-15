import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class PushController extends GetxController {
  final JPush jPush = JPush();

  @override
  void onInit() {
    _initJPush();
    super.onInit();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initJPush() async {
    String? platformVersion;

    try {
      //Map<String, dynamic> message
      jPush.addEventHandler(onReceiveNotification: (message) async {
        print("jpush flutter onReceiveNotification: ${json.encode(message)}");
      }, onOpenNotification: (message) async {
        print("jpush flutter onOpenNotification: ${json.encode(message)}");
      }, onReceiveMessage: (message) async {
        print("jpush flutter onReceiveMessage: ${json.encode(message)}");
      }, onReceiveNotificationAuthorization: (message) async {
        print(
            "jpush flutter onReceiveNotificationAuthorization: ${json.encode(message)}");
      });
    } on PlatformException {
      print("jpush Failed to get platform version.");
    }

    jPush.setup(
      appKey: "646f952e8310ff8c9a336dee", //你自己应用的 AppKey
      channel: "developer-default",
      production: true,
      debug: true,
    );

    jPush.applyPushAuthority(NotificationSettingsIOS(
      sound: true,
      alert: true,
      badge: true,
    ));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jPush.getRegistrationID().then((rid) {
      print("jpush flutter get registration id : $rid");
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  void sendLocalNotification() {
    // 三秒后出发本地推送
    var fireDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 3000);
    var localNotification = LocalNotification(
        id: 234,
        title: 'fadsfa',
        buildId: 1,
        content: 'fdas',
        fireTime: fireDate,
        subtitle: 'fasf',
        badge: 5,
        extra: {"fa": "0"});
    jPush.sendLocalNotification(localNotification).then((res) {
      print("jpush flutter sendLocalNotification :$res");
    });
  }

  void getLaunchAppNotification() {
    jPush.getLaunchAppNotification().then((map) {
      print("jpush flutter getLaunchAppNotification success:$map");
    }).catchError((error) {
      print("jpush flutter getLaunchAppNotification error: $error");
    });
  }

  void setTags() {
    jPush.setTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      print("jpush set tags success: $map $tags");
    }).catchError((error) {
      print("jpush set tags error: $error");
    });
  }

  void addTags() {
    jPush.addTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      print("jpush addTags success: $map $tags");
    }).catchError((error) {
      print("jpush addTags error: $error");
    });
  }

  void deleteTags() {
    jPush.deleteTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      print("jpush deleteTags success: $map $tags");
    }).catchError((error) {
      print("jpush deleteTags error: $error");
    });
  }

  void getAllTags() {
    jPush.getAllTags().then((map) {
      print("jpush getAllTags success: $map");
    }).catchError((error) {
      print("jpush getAllTags error: $error");
    });
  }

  void cleanAllTags() {
    jPush.cleanTags().then((map) {
      var tags = map['tags'];
      print("jpush cleanTags success: $map $tags");
    }).catchError((error) {
      print("jpush cleanTags error: $error");
    });
  }

  void setAlias() {
    jPush.setAlias("thealias11").then((map) {
      print("jpush setAlias success: $map");
    }).catchError((error) {
      print("jpush setAlias error: $error");
    });
  }

  void deleteAlias() {
    jPush.deleteAlias().then((map) {
      print("jpush deleteAlias success: $map");
    }).catchError((error) {
      print("jpush deleteAlias error: $error");
    });
  }

  void setBadge() {
    jPush.setBadge(66).then((map) {
      print("jpush setBadge success: $map");
    }).catchError((error) {
      print("jpush setBadge error: $error");
    });
  }

  void isNotificationEnabled() {
    jPush.isNotificationEnabled().then((bool value) {
      print("jpush 通知授权是否打开: $value");
    }).catchError((onError) {
      print("jpush 通知授权是否打开: ${onError.toString()}");
    });
  }

  void openSettingsForNotification() {
    jPush.openSettingsForNotification();
  }

  Future login(String uid) async {
    await jPush.setAlias(uid).then((map) async {
      print("jpush setAlias success: $map");
    }).catchError((error) {
      print("jpush setAlias error: $error");
    });
    return true;
  }

  Future logout() async {
    jPush.deleteAlias().then((map) async {
      print("jpush deleteAlias success: $map");
    }).catchError((error) {
      print("jpush deleteAlias error: $error");
    });
    return true;
  }
}
