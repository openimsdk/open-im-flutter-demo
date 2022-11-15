import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';

import '../utils/data_persistence.dart';
import '../utils/http_util.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    cachePath = (await getApplicationDocumentsDirectory()).path;
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

    FlutterBugly.init(androidAppId: "4103e474e9", iOSAppId: "28849b1ca6");
  }

  static late String cachePath;

  static const UI_W = 375.0;
  static const UI_H = 812.0;

  /// 默认公司配置
  static final String deptName = "";
  static final String deptID = '0';

  /// 全局字体size在原有ui上增大1.2倍
  static final double textScaleFactor = 1.1;

  /// 秘钥
  static const secret = 'tuoyun';

  /// 使用ip：  http://xxx:端口/、       ws://xxx:端口/
  /// 使用域名： https://xxx/路由/、      wss://xxx/路由/
  static const apiScheme = 'https';
  static const socketScheme = 'wss';

  /// ip
  /// web.rentsoft.cn
  /// test-web.rentsoft.cn
  static const host = "web.rentsoft.cn";

  /// 服务器IP
  static String serverIp() {
    var ip;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
      print('缓存serverIP: $ip');
    }
    return ip ?? host;
  }

  static String get chatTokenBaseURL => '$apiScheme://$host/complete_admin/';

  /// 登录注册手机验 证服务器地址
  static String appAuthUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
      print('缓存authUrl: $url');
    }
    return url ?? "$apiScheme://$host/chat/";
  }

  /// IM sdk api地址
  static String imApiUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
      print('缓存apiUrl: $url');
    }
    return url ?? '$apiScheme://$host/api/';
  }

  /// IM ws 地址
  static String imWsUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
      print('缓存wsUrl: $url');
    }
    return url ?? '$socketScheme://$host/msg_gateway';
  }

  /// 图片存储
  static String objectStorage() {
    var storage;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      storage = server['objectStorage'];
      print('缓存objectStorage: $storage');
    }
    return storage ?? 'minio';
  }
}
