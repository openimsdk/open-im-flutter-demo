
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/utils/http_util.dart';
import 'package:openim_enterprise_chat/src/utils/sp_util.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();

    await SpUtil.init();
    HttpUtil.init();
    runApp();
    // 设置屏幕方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // 状态栏透明（Android）
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: GetPlatform.isAndroid ? Colors.transparent : null,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static const UI_W = 375.0;
  static const UI_H = 812.0;

  /// 秘钥
  static const secret = 'tuoyun';

  // static const HOST = '//10.102.2.61';
  static const HOST = '//47.112.160.66';
  // static const HOST = '//1.14.194.38';
  // static const HOST = '//120.24.45.199';
  static const BASE_URL = 'http:$HOST:10000';

  /// sdk配置的api地址
  static const IP_API = 'http:$HOST:10000';

  /// sdk配置的web socket地址
  static const IP_WS = 'ws:$HOST:17778';
}

