import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class ISUserInfo extends UserInfo with ISuspensionBean {
  ISUserInfo({this.allowAddFriend, this.allowBeep, this.allowVibration, this.forbidden, this.gender, this.phoneNumber, this.birth, this.email})
      : super();

  String? tagIndex;
  String? pinyin;
  String? shortPinyin;
  String? namePinyin;

  /// 是允许添加为好友  1：允许，2：否
  int? allowAddFriend;

  /// 新消息铃声   1：允许，2：否
  int? allowBeep;

  /// 新消息震动   1：允许，2：否
  int? allowVibration;

  /// 禁止登录
  int? forbidden;

  /// 性别
  int? gender;

  /// 手机号
  String? phoneNumber;

  /// 出生时间
  int? birth;

  /// 邮箱
  String? email;

  bool? isFriendship = false;

  bool? isBlacklist = false;

  ISUserInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    tagIndex = json['tagIndex'];
    pinyin = json['pinyin'];
    shortPinyin = json['shortPinyin'];
    namePinyin = json['namePinyin'];
    allowAddFriend = json['allowAddFriend'];
    allowBeep = json['allowBeep'];
    allowVibration = json['allowVibration'];
    forbidden = json['forbidden'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    birth = json['birth'];
    email = json['email'];
  }

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map['tagIndex'] = tagIndex;
    map['pinyin'] = pinyin;
    map['shortPinyin'] = shortPinyin;
    map['namePinyin'] = namePinyin;
    map['allowAddFriend'] = allowAddFriend;
    map['allowBeep'] = allowBeep;
    map['allowVibration'] = allowVibration;
    map['forbidden'] = forbidden;
    map['gender'] = gender;
    map['phoneNumber'] = phoneNumber;
    map['birth'] = birth;
    map['email'] = email;
    return map;
  }

  @override
  String getSuspensionTag() {
    return tagIndex!;
  }

  @override
  String toString() {
    return json.encode(this);
  }
}
