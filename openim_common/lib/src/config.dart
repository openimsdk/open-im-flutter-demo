import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openim_common/openim_common.dart';
import 'package:path_provider/path_provider.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      cachePath = (await getApplicationDocumentsDirectory()).path;
      await DataSp.init();
      await Hive.initFlutter(cachePath);
      // await SpeechToTextUtil.instance.initSpeech();
      HttpUtil.init();
    } catch (_) {}

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

    // FlutterBugly.init(androidAppId: "", iOSAppId: "");
  }

  static late String cachePath;
  static const uiW = 375.0;
  static const uiH = 812.0;

  /// 默认公司配置
  static const String deptName = "OpenIM";
  static const String deptID = '0';

  /// 全局字体size
  static const double textScaleFactor = 1.0;

  /// 秘钥
  static const secret = 'tuoyun';

  static const mapKey = '';

  /// 离线消息默认类型
  static OfflinePushInfo offlinePushInfo = OfflinePushInfo(
    title: StrRes.offlineMessage,
    desc: "",
    iOSBadgeCount: true,
    iOSPushSound: '+1',
  );

  /// 二维码：scheme
  static const friendScheme = "io.openim.app/addFriend/";
  static const groupScheme = "io.openim.app/joinGroup/";

  /// ip
  /// web.rentsoft.cn
  /// test-web.rentsoft.cn
  /// "43.154.157.177"
  /// 43.139.233.109
  static const _host = "203.56.175.233";

  static const _ipRegex =
      '((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)';

  static bool get _isIP => RegExp(_ipRegex).hasMatch(_host);

  /// 服务器IP
  static String get serverIp {
    String? ip;
    var server = DataSp.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
      Logger.print('缓存serverIP: $ip');
    }
    return ip ?? _host;
  }

  /// 商业版管理后台
  /// $apiScheme://$host/complete_admin/
  /// $apiScheme://$host:10009
  /// 端口：10009
  // static String get chatTokenUrl {
  //   String? url;
  //   var server = DataSp.getServerConfig();
  //   if (null != server) {
  //     url = server['chatTokenUrl'];
  //     Logger.print('缓存chatTokenUrl: $url');
  //   }
  //   return url ??
  //       (_isIP ? "http://$_host:10009" : "https://$_host/complete_admin");
  // }

  /// 登录注册手机验 证服务器地址
  /// $apiScheme://$host/chat/
  /// $apiScheme://$host:10008
  /// 端口：10008
  static String get appAuthUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
      Logger.print('缓存authUrl: $url');
    }
    // to b
    // return url ??
    //     (_isIP ? "http://$_host:10010" : "https://$_host/organization");
    // to c
    return url ?? (_isIP ? "http://$_host:10008" : "https://$_host/chat");
  }

  /// IM sdk api地址
  /// $apiScheme://$host/api/
  /// $apiScheme://$host:10002
  /// 端口：10002
  static String get imApiUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
      Logger.print('缓存apiUrl: $url');
    }
    return url ?? (_isIP ? 'http://$_host:10002' : "https://$_host/api");
  }

  /// IM ws 地址
  /// $socketScheme://$host/msg_gateway
  /// $socketScheme://$host:10001
  /// 端口：10001
  static String get imWsUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
      Logger.print('缓存wsUrl: $url');
    }
    return url ?? (_isIP ? "ws://$_host:10001" : "wss://$_host/msg_gateway");
  }

  /// 图片存储
  static String get objectStorage {
    String? storage;
    var server = DataSp.getServerConfig();
    if (null != server) {
      storage = server['objectStorage'];
      Logger.print('缓存objectStorage: $storage');
    }
    return storage ?? 'minio';
  }
}
