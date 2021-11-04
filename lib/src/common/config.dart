
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

  // static const BASE_URL = "https://open-im.rentsoft.cn";

  // static const BASE_URL = 'http://10.102.2.61:10000';
  static const BASE_URL = 'http://47.112.160.66:10000';
  // static const BASE_URL = 'http://1.14.194.38:10000';
  // static const BASE_URL = 'http://120.24.45.199:10000';

  /// sdk配置的api地址
  static const IP_API = BASE_URL;

  /// sdk配置的web socket地址
  // static const IP_WS = 'wss://open-im.rentsoft.cn/wss';
// static const IP_WS = 'ws://10.102.2.61:17778';
static const IP_WS = 'ws://47.112.160.66:17778';
// static const IP_WS = 'ws://1.14.194.38:17778';
// static const IP_WS = 'ws://120.24.45.199:17778';
}
