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
          // a 创建了群聊
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
          // a 修改了群资料
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
          // a 退出了群聊
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
          // final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          // final b = ntf.invitedUserList
          //     ?.map((e) => IMUtils.getGroupMemberShowName(e))
          //     .toList()
          //     .join('、');

          aMap[ntf.opUser!.userID!] =
              IMUtils.getGroupMemberShowName(ntf.opUser!);

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
            // RegExp('($a|$b)'),
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
          // a 邀请 b 加入群聊
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
          // final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          // final a = ntf.opUser!.userID;
          // final b = ntf.kickedUserList
          //     ?.map((e) => IMUtils.getGroupMemberShowName(e))
          //     .toList()
          //     .join('、');

          aMap[ntf.opUser!.userID!] =
              IMUtils.getGroupMemberShowName(ntf.opUser!);

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
            // RegExp('($a|$b)'),
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
          // b 被 a 移出群聊
          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.memberEnterNotification:
        {
          final ntf = EnterGroupNotification.fromJson(map);
          // a 加入了群聊
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
          // a 解散了群聊
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
          // a 将群转让给了 b
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
          // b 被 a 禁言c小时
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
          //  b 被 a 取消了禁言
          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          // a 开起了群禁言
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
          // a 关闭了群禁言
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
          // 你们已成为好友
          return StrRes.friendAddedNtf.toText..style = Styles.ts_8E9AB0_12sp;
        }
      case MessageType.burnAfterReadingNotification:
        {
          final ntf = BurnAfterReadingNotification.fromJson(map);
          // 开启私聊/关闭私聊
          return (ntf.isPrivate == true
                  ? StrRes.openPrivateChatNtf
                  : StrRes.closePrivateChatNtf)
              .toText
            ..style = Styles.ts_8E9AB0_12sp;
        }
      case MessageType.groupMemberInfoChangedNotification:
        final ntf = GroupMemberInfoChangedNotification.fromJson(map);
        // a编辑了自己的群成员资料
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
      case MessageType.groupNameChangedNotification:
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
