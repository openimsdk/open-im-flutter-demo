import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_enterprise_chat/src/common/urls.dart';
import 'package:openim_enterprise_chat/src/models/login_certificate.dart';
import 'package:openim_enterprise_chat/src/models/online_status.dart';
import 'package:openim_enterprise_chat/src/models/upgrade_info.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/utils/http_util.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';

import 'config.dart';

class Apis {
  static int get _platform =>
      Platform.isAndroid ? IMPlatform.android : IMPlatform.ios;
  static final openIMMemberIDS = [
    "18349115126",
    "13918588195",
    "17396220460",
    "18666662412"
  ];
  static final openIMGroupID = '082cad15fd27a2b6b875370e053ccd79';

  /// login
  static Future<LoginCertificate> login({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
  }) async {
    try {
      var data = await HttpUtil.post(Urls.login, data: {
        "areaCode": areaCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': IMUtil.generateMD5(password),
        'platform': _platform,
      });
      return LoginCertificate.fromJson(data);
    } catch (e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('登录失败，请联系管理员:${error.response}');
      return Future.error(e);
    }
  }

  static Future<LoginCertificate> login2(String uid) async {
    try {
      var data = await HttpUtil.post(Urls.login2, data: {
        'secret': Config.secret,
        'platform': _platform,
        'uid': uid,
      });
      return LoginCertificate.fromJson(data);
    } catch (e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('登录失败，请联系管理员:${error.response}');
      return Future.error(e);
    }
  }

  /// register
  static Future<LoginCertificate> register({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String password,
    required String verificationCode,
  }) async {
    try {
      var data = await HttpUtil.post(Urls.register, data: {
        "areaCode": areaCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': IMUtil.generateMD5(password),
        'verificationCode': verificationCode,
      });
      return LoginCertificate.fromJson(data);
    } catch (e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('注册失败，请联系管理员:${error.response}');
      return Future.error(e);
    }
  }

  static Future<bool> register2(
      {required String uid, required String name}) async {
    try {
      await HttpUtil.post(Urls.register2, data: {
        'secret': Config.secret,
        'platform': _platform,
        'uid': uid,
        'name': name,
      });
      return true;
    } catch (e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('注册失败，请联系管理员:${error.response}');
      return false;
    }
  }

  /// 获取验证码
  static Future<bool> requestVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
  }) async {
    return HttpUtil.post(
      Urls.getVerificationCode,
      data: {
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
        "email": email,
      },
    ).then((value) {
      IMWidget.showToast(StrRes.sentSuccessfully);
      return true;
    }).catchError((e) {
      print('e:$e');
      // var error = e as DioError;
      // IMWidget.showToast('发送失败:${error.response}');
      return false;
    });
  }

  /// 校验验证码
  static Future<dynamic> checkVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verificationCode,
  }) {
    return HttpUtil.post(
      Urls.checkVerificationCode,
      data: {
        "phoneNumber": phoneNumber,
        "areaCode": areaCode,
        "email": email,
        "verificationCode": verificationCode,
      },
    );
  }

  /////////////////////////////////////////////////////////
  /// 为用户导入好友OpenIM成员
  static Future<bool> importFriends(
      {required String uid, required String token}) async {
    try {
      await HttpUtil.post(
        Urls.importFriends,
        data: {
          "uidList": openIMMemberIDS,
          "ownerUid": uid,
          "operationID": "1111111111111",
        },
        options: Options(headers: {'token': token}),
      );
      return true;
    } catch (e) {
      print('e:$e');
    }
    return false;
  }

  /// 拉用户进OpenIM官方体验群
  static Future<bool> inviteToGroup(
      {required String uid, required String token}) async {
    try {
      await dio.post(
        Urls.inviteToGroup,
        data: {
          "groupID": openIMGroupID,
          "uidList": [uid],
          "reason": "Welcome join openim group",
          "operationID": "1111111111111"
        },
        options: Options(headers: {'token': token}),
      );
      return true;
    } catch (e) {
      print('e:$e');
    }
    return false;
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

  static Future<List<OnlineStatus>> onlineStatus(
      {required List<String> uidList}) {
    return dio.post<Map<String, dynamic>>(Urls.onlineStatus, data: {
      "operationID": "sdfasfasfdasfda",
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
}
