import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatRevokeView extends StatelessWidget {
  const ChatRevokeView({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  bool get _isISend => message.sendID == OpenIM.iMManager.userID;

  String get _who => _isISend ? StrRes.you : message.senderNickname ?? '';

  @override
  Widget build(BuildContext context) {
    final bridge = PackageBridge.viewUserProfileBridge;
    final groupID = message.groupID;
    String? revoker, sender;
    final value = <String, String>{};

    var map = json.decode(message.notificationElem!.detail!);
    var info = RevokedInfo.fromJson(map);
    if (info.revokerID == info.sourceMessageSendID) {
      revoker = _who;
    } else {
      if (info.revokerID == OpenIM.iMManager.userID) {
        revoker = info.revokerID!;
        value[revoker] = StrRes.you;
      } else {
        revoker = info.revokerID!;
        value[revoker] = info.revokerNickname!;
      }
      if (info.sourceMessageSendID == OpenIM.iMManager.userID) {
        sender = info.sourceMessageSendID!;
        value[sender] = StrRes.you;
      } else {
        sender = info.sourceMessageSendID!;
        value[sender] = info.sourceMessageSenderNickname!;
      }
    }

    final List<InlineSpan> children = <InlineSpan>[];
    if (sender != null) {
      final text = sprintf(StrRes.aRevokeBMsg, [revoker, sender]);
      text.splitMapJoin(
        RegExp('($revoker|$sender)'),
        onMatch: (match) {
          final matchText = match[0]!;
          final nickname = value[matchText];
          children.add(TextSpan(
            text: nickname,
            style: Styles.ts_0089FF_12sp,
            recognizer: TapGestureRecognizer()
              ..onTap = () => bridge?.viewUserProfile(
                    matchText,
                    nickname,
                    null,
                    groupID,
                  ),
          ));
          return '';
        },
        onNonMatch: (text) {
          children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
          return '';
        },
      );
    } else {
      children
        ..add(TextSpan(
          text: '$revoker ',
          style: Styles.ts_0089FF_12sp,
          recognizer: TapGestureRecognizer()
            ..onTap = () => bridge?.viewUserProfile(
                  info.sourceMessageSendID!,
                  info.revokerNickname,
                  null,
                  groupID,
                ),
        ))
        ..add(TextSpan(
          text: StrRes.revokeMsg,
          style: Styles.ts_8E9AB0_12sp,
        ));
    }
    return RichText(
      text: TextSpan(children: children),
      textAlign: TextAlign.center,
    );
  }
}
