import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';

class TagNotification {
  String? id;
  List<TagInfo>? tags;
  List<UserInfo>? users;
  List<GroupInfo>? groups;
  int? sendTime;
  String? content;

  TagNotification(
      {this.id,
      this.tags,
      this.users,
      this.groups,
      this.content,
      this.sendTime});

  TagNotification.fromJson(Map<String, dynamic> json) {
    tags = null != json['tags']
        ? (json['tags'] as List).map((e) => TagInfo.fromJson(e)).toList()
        : null;
    users = null != json['users']
        ? (json['users'] as List).map((e) => UserInfo.fromJson(e)).toList()
        : null;
    groups = null != json['groups']
        ? (json['groups'] as List).map((e) => GroupInfo.fromJson(e)).toList()
        : null;
    sendTime = json['sendTime'];
    content = json['content'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tags'] = tags?.map((e) => e.toJson()).toList();
    data['users'] = users?.map((e) => e.toJson()).toList();
    data['groups'] = groups?.map((e) => e.toJson()).toList();
    data['sendTime'] = sendTime;
    data['content'] = content;
    data['id'] = id;
    return data;
  }

  TagNotificationContent? parseContent() {
    if (null != content) {
      try {
        final customElem = CustomElem.fromJson(jsonDecode(content!));
        if (null != customElem.data) {
          final json = jsonDecode(customElem.data!);
          // final customType = json['customType'];
          return TagNotificationContent.fromJson(json['data']);
        }
      } catch (e, s) {
        Logger.print('$e  $s');
      }
    }
    return null;
  }
}

class TagNotificationContent {
  TextElem? textElem;
  SoundElem? soundElem;
  PictureElem? pictureElem;
  VideoElem? videoElem;
  FileElem? fileElem;
  CardElem? cardElem;
  LocationElem? locationElem;

  TagNotificationContent({
    this.textElem,
    this.soundElem,
    this.pictureElem,
    this.videoElem,
    this.fileElem,
    this.cardElem,
    this.locationElem,
  });

  TagNotificationContent.fromJson(Map<String, dynamic> json) {
    if (null != json['textElem']) {
      textElem = TextElem.fromJson(json['textElem']);
    }
    if (null != json['soundElem']) {
      soundElem = SoundElem.fromJson(json['soundElem']);
    }
    if (null != json['pictureElem']) {
      pictureElem = PictureElem.fromJson(json['pictureElem']);
    }
    if (null != json['videoElem']) {
      videoElem = VideoElem.fromJson(json['videoElem']);
    }
    if (null != json['fileElem']) {
      fileElem = FileElem.fromJson(json['fileElem']);
    }
    if (null != json['cardElem']) {
      cardElem = CardElem.fromJson(json['cardElem']);
    }
    if (null != json['locationElem']) {
      locationElem = LocationElem.fromJson(json['locationElem']);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['textElem'] = textElem?.toJson();
    data['soundElem'] = soundElem?.toJson();
    data['pictureElem'] = pictureElem?.toJson();
    data['videoElem'] = videoElem?.toJson();
    data['fileElem'] = fileElem?.toJson();
    data['cardElem'] = cardElem?.toJson();
    data['locationElem'] = locationElem?.toJson();
    return data;
  }
}
