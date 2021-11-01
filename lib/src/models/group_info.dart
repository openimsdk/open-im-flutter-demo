import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;

class GroupInfo extends im.GroupInfo with ISuspensionBean {
  String? tagIndex;
  String? pinyin;
  String? shortPinyin;
  String? namePinyin;

  GroupInfo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    tagIndex = json['tagIndex'];
    pinyin = json['pinyin'];
    shortPinyin = json['shortPinyin'];
    namePinyin = json['namePinyin'];
  }

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map['tagIndex'] = tagIndex;
    map['pinyin'] = pinyin;
    map['shortPinyin'] = shortPinyin;
    map['namePinyin'] = namePinyin;
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
