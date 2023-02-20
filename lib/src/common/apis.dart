import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_demo/src/common/urls.dart';
import 'package:openim_demo/src/models/login_certificate.dart';
import 'package:openim_demo/src/models/online_status.dart';
import 'package:openim_demo/src/models/upgrade_info.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/utils/http_util.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

import '../utils/data_persistence.dart';
import 'config.dart';

class Apis {
  static int get _platform =>
      Platform.isAndroid ? IMPlatform.android : IMPlatform.ios;
  static final openIMMemberIDS = [
  ];
  static final openIMGroupID = '082cad15fd27a2b6b875370e053ccd79';

  /// login
  static Future<LoginCertificate> login({
    String? areaCode,
    String? phoneNumber,
    String? email,
    String? password,
    String? code,
  }) async {
    try {
      var data = await HttpUtil.post(Urls.login, data: {
        "areaCode": areaCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': IMUtil.generateMD5(password),
        'platform': await IMUtil.getPlatform(),
        'code': code,
        'operationID': _getOperationID(),
      });
      return LoginCertificate.fromJson(data!);
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  /// register
  static Future<LoginCertificate> setPassword(
      {required String nickname,
      required String password,
      required String verificationCode,
      String? faceURL,
      String? areaCode,
      String? phoneNumber,
      String? email,
      int birth = 0,
      int gender = 1,
      String? invitationCode,
      int? platformID}) async {
    try {
      var data = await HttpUtil.post(Urls.setPwd, data: {
        "nickname": nickname,
        "faceURL": faceURL ?? '',
        "areaCode": areaCode,
        'phoneNumber': phoneNumber,
        'email': email ?? '',
        'birth': birth,
        'gender': gender,
        'deviceID': DataPersistence.getDeviceID(),
        'password': IMUtil.generateMD5(password),
        'verificationCode': verificationCode,
        'platform': await IMUtil.getPlatform(),
        'operationID': _getOperationID(),
        'invitationCode': invitationCode,
      });
      return LoginCertificate.fromJson(data!);
    } catch (e) {
      print('e:$e');
      return Future.error(e);
    }
  }

  /// reset password
  static Future<dynamic> resetPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
    required String verificationCode,
  }) async {
    return HttpUtil.post(Urls.resetPwd, data: {
      "areaCode": areaCode,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': IMUtil.generateMD5(password),
      'verificationCode': verificationCode,
      'platform': await IMUtil.getPlatform(),
      'operationID': _getOperationID(),
    });
  }

  /// change password
  static Future<bool> changePassword({
    required String userID,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await HttpUtil.post(Urls.changePwd, data: {
        "userID": userID,
        'currentPassword': IMUtil.generateMD5(currentPassword),
        'newPassword': IMUtil.generateMD5(newPassword),
        'platform': await IMUtil.getPlatform(),
        'operationID': _getOperationID(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// update user info
  static Future<dynamic> updateUserInfo({
    required String userID,
    String? account,
    String? phoneNumber,
    String? areaCode,
    String? email,
    String? nickname,
    String? faceURL,
    int? gender,
    int? birth,
    int? level,
    int? allowAddFriend,
    int? allowBeep,
    int? allowVibration,
  }) async {
    Map<String, dynamic> param = {'userID': userID};
    void put(String key, dynamic value) {
      if (null != value) {
        param[key] = value;
      }
    }

    put('account', account);
    put('phoneNumber', phoneNumber);
    put('areaCode', areaCode);
    put('email', email);
    put('nickname', nickname);
    put('faceURL', faceURL);
    put('gender', gender);
    put('gender', gender);
    put('level', level);
    put('birth', birth);
    put('allowAddFriend', allowAddFriend);
    put('allowBeep', allowBeep);
    put('allowVibration', allowVibration);

    return HttpUtil.post(
      Urls.updateUserInfo,
      data: {
        ...param,
        'platform': await IMUtil.getPlatform(),
        'operationID': _getOperationID(),
      },
      options: chatTokenOptions,
    );
  }

  /// reset password
  static Future<dynamic> getUsersFullInfo({
    int pageNumber = 0,
    int showNumber = 100,
    required List<String> userIDList,
  }) async {
    return HttpUtil.post(
      Urls.getUsersFullInfo,
      data: {
        'pageNumber': pageNumber,
        'showNumber': showNumber,
        'userIDList': userIDList,
        'platform': await IMUtil.getPlatform(),
        'operationID': _getOperationID(),
      },
      options: chatTokenOptions,
    );
  }

  static Future<dynamic> queryMyFullInfo() async {
    final data = await Apis.getUsersFullInfo(
      userIDList: [OpenIM.iMManager.uid],
    );
    if (data['userFullInfoList'] is List) {
      List list = data['userFullInfoList'];
      return list.firstOrNull;
    }
    return null;
  }

  static Future<dynamic> searchUserFullInfo({
    required String content,
    int pageNumber = 0,
    int showNumber = 10,
  }) async {
    final data = await HttpUtil.post(
      Urls.searchUserFullInfo,
      data: {
        'pageNumber': pageNumber,
        'showNumber': showNumber,
        'content': content,
        'operationID': _getOperationID(),
      },
      options: chatTokenOptions,
    );
    if (data['userFullInfoList'] is List) {
      return data['userFullInfoList'];
    }
    return null;
  }

  /// 获取验证码
  /// [usedFor] 1：注册，2：重置密码
  static Future<bool> requestVerificationCode(
      {String? areaCode,
      String? phoneNumber,
      String? email,
      required int usedFor,
      String? invitationCode}) async {
    return HttpUtil.post(
      Urls.getVerificationCode,
      data: {
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
        "email": email,
        'operationID': _getOperationID(),
        'usedFor': usedFor,
        'invitationCode': invitationCode
      },
    ).then((value) {
      IMWidget.showToast(StrRes.sentSuccessfully);
      return true;
    }).catchError((e) {
      print('e:$e');
      return false;
    });
  }

  /// 校验验证码
  static Future<dynamic> checkVerificationCode(
      {String? areaCode,
      String? phoneNumber,
      String? email,
      required String verificationCode,
      required int usedFor,
      String? invitationCode}) {
    return HttpUtil.post(
      Urls.checkVerificationCode,
      data: {
        "phoneNumber": phoneNumber,
        "areaCode": areaCode,
        "email": email,
        "verificationCode": verificationCode,
        "usedFor": usedFor,
        'operationID': _getOperationID(),
        'invitationCode': invitationCode
      },
    );
  }
  static Future<UpgradeInfoV2> checkUpgradeV2() {
    return dio.post<Map<String, dynamic>>(
      'https://www.pgyer.com/apiv2/app/check',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
      data: {
        '_api_key': 'a8d237955358a873cb9472d6df198490',
        'appKey': 'ae0f3138d2c3ca660039945ffd70adb6',
      },
    ).then((resp) {
      Map<String, dynamic> map = resp.data!;
      if (map['code'] == 0) {
        return UpgradeInfoV2.fromJson(map['data']);
      }
      return Future.error(map);
    });
  }

  static Future<List<OnlineStatus>> _onlineStatus(
      {required List<String> uidList}) {
    return dio.post<Map<String, dynamic>>(Urls.onlineStatus, data: {
      'operationID': _getOperationID(),
      "secret": Config.secret,
      "userIDList": uidList
    }).then((resp) {
      Map<String, dynamic> map = resp.data!;
      if (map['errCode'] == 0) {
        return (map['successResult'] as List)
            .map((e) => OnlineStatus.fromJson(e))
            .toList();
      }
      return Future.error(map);
    });
  }

  /// 每次最多查询200条
  static void queryOnlineStatus({
    required List<String> uidList,
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) {
    // if (uidList.isEmpty) return;
    // var batch = uidList.length ~/ 200;
    // var remainder = uidList.length % 200;
    // var i = 0;
    // var subList;
    // if (batch > 0) {
    //   for (; i < batch; i++) {
    //     subList = uidList.sublist(i * 200, 200 * (i + 1));
    //     Apis._onlineStatus(uidList: subList).then((list) => _handleStatus(
    //           list,
    //           onlineStatusCallback: onlineStatusCallback,
    //           onlineStatusDescCallback: onlineStatusDescCallback,
    //         ));
    //   }
    // }
    // if (remainder > 0) {
    //   if (i > 0) {
    //     subList = uidList.sublist(i * 200, 200 * i + remainder);
    //     Apis._onlineStatus(uidList: subList).then((list) => _handleStatus(
    //           list,
    //           onlineStatusCallback: onlineStatusCallback,
    //           onlineStatusDescCallback: onlineStatusDescCallback,
    //         ));
    //   } else {
    //     subList = uidList.sublist(0, remainder);
    //     Apis._onlineStatus(uidList: subList).then((list) => _handleStatus(
    //           list,
    //           onlineStatusCallback: onlineStatusCallback,
    //           onlineStatusDescCallback: onlineStatusDescCallback,
    //         ));
    //   }
    // }
  }

  static _handleStatus(
    List<OnlineStatus> list, {
    Function(Map<String, String>)? onlineStatusDescCallback,
    Function(Map<String, bool>)? onlineStatusCallback,
  }) {
    final statusDesc = <String, String>{};
    final status = <String, bool>{};
    list.forEach((e) {
      if (e.status == 'online') {
        // IOSPlatformStr     = "IOS"
        // AndroidPlatformStr = "Android"
        // WindowsPlatformStr = "Windows"
        // OSXPlatformStr     = "OSX"
        // WebPlatformStr     = "Web"
        // MiniWebPlatformStr = "MiniWeb"
        // LinuxPlatformStr   = "Linux"
        final pList = <String>[];
        for (var platform in e.detailPlatformStatus!) {
          if (platform.platform == "Android" || platform.platform == "IOS") {
            pList.add(StrRes.phoneOnline);
          } else if (platform.platform == "Windows") {
            pList.add(StrRes.pcOnline);
          } else if (platform.platform == "Web") {
            pList.add(StrRes.webOnline);
          } else if (platform.platform == "MiniWeb") {
            pList.add(StrRes.webMiniOnline);
          } else {
            statusDesc[e.userID!] = StrRes.online;
          }
        }
        statusDesc[e.userID!] = '${pList.join('/')}${StrRes.online}';
        status[e.userID!] = true;
      } else {
        statusDesc[e.userID!] = StrRes.offline;
        status[e.userID!] = false;
      }
    });
    onlineStatusDescCallback?.call(statusDesc);
    onlineStatusCallback?.call(status);
  }

  static String _getOperationID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static Options get chatTokenOptions => Options(
      headers: {'token': DataPersistence.getLoginCertificate()!.chatToken});

  /// discoverPageURL
  /// ordinaryUserAddFriend,
  /// bossUserID,
  /// adminURL ,
  /// allowSendMsgNotFriend
  /// needInvitationCodeRegister
  /// robots
  static Future<Map<String, dynamic>> getClientConfig() async {
    var result = await HttpUtil.post(
      Urls.getClientConfig,
      data: {'operationID': _getOperationID()},
      // options: chatTokenOptions,
      showErrorToast: false,
    );
    return result;
  }
}
