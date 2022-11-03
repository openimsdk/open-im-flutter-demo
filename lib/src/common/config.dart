import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:sp_util/sp_util.dart';

import '../utils/data_persistence.dart';
import '../utils/http_util.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
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

    FlutterBugly.init(androidAppId: "", iOSAppId: "");
  }

  static const UI_W = 375.0;
  static const UI_H = 812.0;

  /// 默认公司配置
  static final String deptName = "托云信息技术（成都）有限公司";
  static final String deptID = '0';

  /// 全局字体size在原有ui上增大1.2倍
  static final double textScaleFactor = 1.1;

  /// 秘钥
  static const secret = 'tuoyun';

  static const apiScheme = 'https';
  static const socketScheme = 'wss';

  /// ip
  static const host = "open-im-online.rentsoft.cn";

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

  /// 登录注册手机验 证服务器地址
  static String appAuthUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
      print('缓存authUrl: $url');
    }
    return url ?? "$apiScheme://$host:50004";
  }

  /// IM sdk api地址
  static String imApiUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
      print('缓存apiUrl: $url');
    }
    return url ?? '$apiScheme://$host:50002';
  }

  /// IM ws 地址
  static String imWsUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
      print('缓存wsUrl: $url');
    }
    return url ?? '$socketScheme://$host:50001';
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
