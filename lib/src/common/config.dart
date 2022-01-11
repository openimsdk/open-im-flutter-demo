import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/http_util.dart';
import 'package:openim_demo/src/utils/speech_to_text_util.dart';
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

  // static const BASE_URL = "https://open-im.rentsoft.cn";
  // static const BASE_URL = 'http://10.102.2.61:10000';
  // static const BASE_URL = 'http://47.112.160.66:10000';
  // static const BASE_URL = 'http://1.14.194.38:10000';
  // static const BASE_URL = 'http://120.24.45.199:10000';

  /// sdk配置的api地址
  // static const IP_API = BASE_URL;

  /// sdk配置的web socket地址
  // static const IP_WS = 'wss://open-im.rentsoft.cn/wss';
  // static const IP_WS = 'ws://10.102.2.61:17778';
  // static const IP_WS = 'ws://47.112.160.66:17778';
  // static const IP_WS = 'ws://1.14.194.38:17778';

  // static const IP_WS = 'ws://120.24.45.199:17778';

  // static const AUTH_URL = "http://1.14.194.38:42233";

  // static const ION_CLUSTER_URL = 'http://1.14.194.38:5551';

  // static const ION_SFU_URL = 'http://1.14.194.38:9090';

  /// 服务器IP
  static String serverIp() {
    var ip;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
      print('缓存serverIP: $ip');
    }
    return ip ?? "121.37.25.71";
  }

  /// 登录注册手机验 证服务器地址
  static String appAuthUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
      print('缓存authUrl: $url');
    }
    return url ?? "http://121.37.25.71:42233";
  }

  /// IM sdk api地址
  static String imApiUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
      print('缓存apiUrl: $url');
    }
    return url ?? 'http://121.37.25.71:10000';
  }

  /// IM ws 地址
  static String imWsUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
      print('缓存wsUrl: $url');
    }
    return url ?? 'ws://121.37.25.71:17778';
  }

  /// 音视频通话地址
  static String callUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['callUrl'];
      print('缓存callUrl: $url');
    }
    return url ?? 'http://121.37.25.71:5551';
  }
}
