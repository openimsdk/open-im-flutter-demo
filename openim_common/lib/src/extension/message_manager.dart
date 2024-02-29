import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';

extension MessageManagerExt on MessageManager {
  Future<Message> createCallMessage({
    required String type,
    required String state,
    int? duration,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.call,
          "data": {
            'duration': duration,
            'state': state,
            'type': type,
          },
        }),
        extension: '',
        description: '',
      );

  Future<Message> createCustomEmojiMessage({
    required String url,
    int? width,
    int? height,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.emoji,
          "data": {
            'url': url,
            'width': width,
            'height': height,
          },
        }),
        extension: '',
        description: '',
      );

  Future<Message> createTagMessage({
    String? url,
    int? duration,
    String? text,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.tag,
          "data": {
            'url': url,
            'duration': duration,
            'text': text,
          },
        }),
        extension: '',
        description: '',
      );

  Future<Message> createMeetingMessage({
    required String inviterUserID,
    required String inviterNickname,
    String? inviterFaceURL,
    required String subject,
    required String id,
    required int start,
    required int duration,
  }) =>
      createCustomMessage(
          data: json.encode({
            "customType": CustomMessageType.meeting,
            "data": {
              'inviterUserID': inviterUserID,
              'inviterNickname': inviterNickname,
              'inviterFaceURL': inviterFaceURL,
              'subject': subject,
              'id': id,
              'start': start,
              'duration': duration,
            },
          }),
          extension: '',
          description: '');

  Future<Message> createFailedHintMessage({required int type}) => createCustomMessage(
        data: json.encode({
          "customType": type,
          "data": {},
        }),
        extension: '',
        description: '',
      );
}

extension MessageExt on Message {
  Message? get quoteMessage {
    Message? quoteMsg;
    if (contentType == MessageType.quote) {
      quoteMsg = quoteElem?.quoteMessage;
    } else if (contentType == MessageType.atText) {
      quoteMsg = atTextElem?.quoteMessage;
    }
    return quoteMsg;
  }

  bool get isNoticeType {
    final isGroupNtf = contentType! == MessageType.groupInfoSetNotification;
    if (isGroupNtf) {
      try {
        final map = json.decode(notificationElem!.detail!);
        final ntf = GroupNotification.fromJson(map);
        return IMUtils.isNotNullEmptyStr(ntf.group?.notification);
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  String? get noticeContent {
    final isGroupNtf = contentType! == MessageType.groupInfoSetAnnouncementNotification;
    if (isGroupNtf) {
      try {
        final map = json.decode(notificationElem!.detail!);
        final ntf = GroupNotification.fromJson(map);
        return ntf.group?.notification;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return null;
  }

  bool get isCallType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.call == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  bool get isMeetingType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.meeting == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  bool get isDeletedByFriendType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.deletedByFriend == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  bool get isBlockedByFriendType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.blockedByFriend == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  bool get isEmojiType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.emoji == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  bool get isTagType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.tag == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  TagNotificationContent? get tagContent {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        if (CustomMessageType.tag == customType) {
          var data = map['data'];
          if (null != data) {
            return TagNotificationContent.fromJson(data);
          }
        }
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return null;
  }

  bool get isTextType => contentType == MessageType.text;

  bool get isAtTextType => contentType == MessageType.atText;

  bool get isPictureType => contentType == MessageType.picture;

  bool get isVoiceType => contentType == MessageType.voice;

  bool get isVideoType => contentType == MessageType.video;

  bool get isFileType => contentType == MessageType.file;

  bool get isLocationType => contentType == MessageType.location;

  bool get isQuoteType => contentType == MessageType.quote;

  bool get isMergerType => contentType == MessageType.merger;

  bool get isCardType => contentType == MessageType.card;

  bool get isCustomFaceType => contentType == MessageType.customFace;

  bool get isCustomType => contentType == MessageType.custom;

  bool get isRevokeType => contentType == MessageType.revokeMessageNotification;

  bool get isNotificationType => contentType! >= 1000;
}

class CustomMessageType {
  static const callingInvite = 200;
  static const callingAccept = 201;
  static const callingReject = 202;
  static const callingCancel = 203;
  static const callingHungup = 204;

  static const call = 901;
  static const emoji = 902;
  static const tag = 903;
  static const moments = 904;
  static const meeting = 905;
  static const blockedByFriend = 910;
  static const deletedByFriend = 911;
  static const removedFromGroup = 912;
  static const groupDisbanded = 913;
}

extension FullUserInfoExt on FullUserInfo {
  UserInfo get simpleUserInfo {
    return UserInfo(userID: userID, nickname: nickname, faceURL: faceURL);
  }
}
