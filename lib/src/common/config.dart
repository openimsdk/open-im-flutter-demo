import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/http_util.dart';
import 'package:sp_util/sp_util.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    // await SpeechToTextUtil.instance.initSpeech();
    HttpUtil.init();
    runApp();
    // 设置屏幕方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 状态栏透明（Android）
    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));

    // FlutterBugly.init(androidAppId: "4103e474e9", iOSAppId: "28849b1ca6");
  }

  static const UI_W = 375.0;
  static const UI_H = 812.0;

  /// 秘钥
  static const secret = 'tuoyun';

  /// ip
  static const defaultIp = "121.37.25.71"; //43.128.5.63"; //121.37.25.71

  /// 服务器IP
  static String serverIp() {
    var ip;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
      print('缓存serverIP: $ip');
    }
    return ip ?? defaultIp;
  }

  /// 登录注册手机验 证服务器地址
  static String appAuthUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
      print('缓存authUrl: $url');
    }
    return url ?? "http://$defaultIp:10004";
  }

  /// IM sdk api地址
  static String imApiUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
      print('缓存apiUrl: $url');
    }
    return url ?? 'http://$defaultIp:10002';
  }

  /// IM ws 地址
  static String imWsUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
      print('缓存wsUrl: $url');
    }
    return url ?? 'ws://$defaultIp:10001';
  }

  /// 存储对象
  static String objectStorage(){
    var objectStorage;
    var server = DataPersistence.getServerConfig();
    if (null !=server){
      objectStorage = server['objectStorage'];
      print('缓存objectStorage: $objectStorage');
    }
    return objectStorage ?? 'cos';
  }
  /// 音视频通话地址
  static String callUrl() {
    return '';
  }
}
