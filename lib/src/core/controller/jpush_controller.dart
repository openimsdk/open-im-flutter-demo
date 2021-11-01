import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JPushController extends GetxController {
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
        print("flutter onReceiveNotification: $message");
      }, onOpenNotification: (message) async {
        print("flutter onOpenNotification: $message");
      }, onReceiveMessage: (message) async {
        print("flutter onReceiveMessage: $message");
      }, onReceiveNotificationAuthorization: (message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
      });
    } on PlatformException {
      print("Failed to get platform version.");
    }

    jPush.setup(
      appKey: "cf47465a368f24c659608e7e", //你自己应用的 AppKey
      channel: "developer-default",
      production: false,
      debug: true,
    );

    jPush.applyPushAuthority(NotificationSettingsIOS(
      sound: true,
      alert: true,
      badge: true,
    ));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jPush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
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
      print("flutter sendLocalNotification :$res");
    });
  }

  void getLaunchAppNotification() {
    jPush.getLaunchAppNotification().then((map) {
      print("flutter getLaunchAppNotification success:$map");
    }).catchError((error) {
      print("flutter getLaunchAppNotification error: $error");
    });
  }

  void setTags() {
    jPush.setTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      print("set tags success: $map $tags");
    }).catchError((error) {
      print("set tags error: $error");
    });
  }

  void addTags() {
    jPush.addTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      print("addTags success: $map $tags");
    }).catchError((error) {
      print("addTags error: $error");
    });
  }

  void deleteTags() {
    jPush.deleteTags(["lala", "haha"]).then((map) {
      var tags = map['tags'];
      print("deleteTags success: $map $tags");
    }).catchError((error) {
      print("deleteTags error: $error");
    });
  }

  void getAllTags() {
    jPush.getAllTags().then((map) {
      print("getAllTags success: $map");
    }).catchError((error) {
      print("getAllTags error: $error");
    });
  }

  void cleanAllTags() {
    jPush.cleanTags().then((map) {
      var tags = map['tags'];
      print("cleanTags success: $map $tags");
    }).catchError((error) {
      print("cleanTags error: $error");
    });
  }

  void setAlias() {
    jPush.setAlias("thealias11").then((map) {
      print("setAlias success: $map");
    }).catchError((error) {
      print("setAlias error: $error");
    });
  }

  void deleteAlias() {
    jPush.deleteAlias().then((map) {
      print("deleteAlias success: $map");
    }).catchError((error) {
      print("deleteAlias error: $error");
    });
  }

  void setBadge() {
    jPush.setBadge(66).then((map) {
      print("setBadge success: $map");
    }).catchError((error) {
      print("setBadge error: $error");
    });
  }

  void isNotificationEnabled() {
    jPush.isNotificationEnabled().then((bool value) {
      print("通知授权是否打开: $value");
    }).catchError((onError) {
      print("通知授权是否打开: ${onError.toString()}");
    });
  }

  void openSettingsForNotification() {
    jPush.openSettingsForNotification();
  }

  Future login(String uid) async {
   /* await jPush.setAlias(uid).then((map) {
      print("setAlias success: $map");
    }).catchError((error) {
      print("setAlias error: $error");
    });*/
    return true;
  }

  Future logout() async {
    /*await jPush.deleteAlias().then((map) async {
      print("deleteAlias success: $map");
    }).catchError((error) {
      print("deleteAlias error: $error");
    });*/
    return true;
  }
}
