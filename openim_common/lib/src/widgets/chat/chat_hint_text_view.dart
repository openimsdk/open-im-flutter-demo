import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatHintTextView extends StatelessWidget {
  const ChatHintTextView({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    final elem = message.notificationElem!;
    final map = json.decode(elem.detail!);
    switch (message.contentType) {
      case MessageType.groupCreatedNotification:
        {
          final ntf = GroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf(StrRes.createGroupNtf, ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupInfoSetNotification:
        {
          final ntf = GroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf(StrRes.editGroupInfoNtf, ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.memberQuitNotification:
        {
          final ntf = QuitGroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.quitUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf(StrRes.quitGroupNtf, ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.memberInvitedNotification:
        {
          final aMap = <String, String>{};
          final bMap = <String, String>{};
          final ntf = InvitedJoinGroupNotification.fromJson(map);

          aMap[ntf.opUser!.userID!] = IMUtils.getGroupMemberShowName(ntf.opUser!);

          for (var user in ntf.invitedUserList!) {
            bMap[user.userID!] = IMUtils.getGroupMemberShowName(user);
          }

          final a = ntf.opUser!.userID!;
          final b = bMap.keys.join('、');
          String pattern = '(${[a, ...bMap.keys].join('|')})';

          final text = sprintf(StrRes.invitedJoinGroupNtf, [a, b]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp(pattern),
            onMatch: (match) {
              final text = match[0]!;
              final value = aMap[text] ?? bMap[text] ?? '';
              children.add(TextSpan(text: value, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.memberKickedNotification:
        {
          final aMap = <String, String>{};
          final bMap = <String, String>{};
          final ntf = KickedGroupMemeberNotification.fromJson(map);

          aMap[ntf.opUser!.userID!] = IMUtils.getGroupMemberShowName(ntf.opUser!);

          for (var user in ntf.kickedUserList!) {
            bMap[user.userID!] = IMUtils.getGroupMemberShowName(user);
          }

          final a = ntf.opUser!.userID!;
          final b = bMap.keys.join('、');
          String pattern = '(${[a, ...bMap.keys].join('|')})';

          final text = sprintf(StrRes.kickedGroupNtf, [b, a]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp(pattern),
            onMatch: (match) {
              final text = match[0]!;
              final value = aMap[text] ?? bMap[text] ?? '';
              children.add(TextSpan(text: value, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.memberEnterNotification:
        {
          final ntf = EnterGroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.entrantUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf(StrRes.joinGroupNtf, ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.dismissGroupNotification:
        {
          final ntf = GroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf(StrRes.dismissGroupNtf, ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupOwnerTransferredNotification:
        {
          final ntf = GroupRightsTransferNoticication.fromJson(map);
          final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          final b = IMUtils.getGroupMemberShowName(ntf.newGroupOwner!);
          final text = sprintf(StrRes.transferredGroupNtf, [a, b]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              children.add(TextSpan(text: text, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMemberMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          final b = IMUtils.getGroupMemberShowName(ntf.mutedUser!);
          final c = IMUtils.mutedTime(ntf.mutedSeconds!);
          final text = sprintf(StrRes.muteMemberNtf, [b, a, c]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              children.add(TextSpan(text: text, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMemberCancelMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          final b = IMUtils.getGroupMemberShowName(ntf.mutedUser!);
          final text = sprintf(StrRes.muteCancelMemberNtf, [b, a]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              children.add(TextSpan(text: text, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf(StrRes.muteGroupNtf, ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupCancelMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf(StrRes.muteCancelGroupNtf, ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.friendApplicationApprovedNotification:
        {
          return StrRes.friendAddedNtf.toText..style = Styles.ts_8E9AB0_12sp;
        }
      case MessageType.burnAfterReadingNotification:
        {
          final ntf = BurnAfterReadingNotification.fromJson(map);

          return (ntf.isPrivate == true ? StrRes.openPrivateChatNtf : StrRes.closePrivateChatNtf).toText..style = Styles.ts_8E9AB0_12sp;
        }
      case MessageType.groupMemberInfoChangedNotification:
        final ntf = GroupMemberInfoChangedNotification.fromJson(map);

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: IMUtils.getGroupMemberShowName(ntf.opUser!),
            style: Styles.ts_0089FF_12sp,
            children: [
              TextSpan(
                text: sprintf(StrRes.memberInfoChangedNtf, ['']),
                style: Styles.ts_8E9AB0_12sp,
              ),
            ],
          ),
        );
      case MessageType.groupInfoSetNameNotification:
        final ntf = GroupNotification.fromJson(map);
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: IMUtils.getGroupMemberShowName(ntf.opUser!),
            style: Styles.ts_0089FF_12sp,
            children: [
              TextSpan(
                text: sprintf(StrRes.whoModifyGroupName, ['']),
                style: Styles.ts_8E9AB0_12sp,
              ),
            ],
          ),
        );
    }
    return const SizedBox();
  }
}
