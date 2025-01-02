import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatReadTagView extends StatelessWidget {
  const ChatReadTagView({
    Key? key,
    required this.message,
    this.onTap,
  }) : super(key: key);
  final Message message;
  final Function()? onTap;

  int get _needReadMemberCount {
    final hasReadCount = message.attachedInfoElem?.groupHasReadInfo?.hasReadCount ?? 0;
    final unreadCount = message.attachedInfoElem?.groupHasReadInfo?.unreadCount ?? 0;
    return hasReadCount + unreadCount;
  }

  int get _unreadCount => message.attachedInfoElem?.groupHasReadInfo?.unreadCount ?? 0;

  bool get isRead => message.isRead!;

  @override
  Widget build(BuildContext context) {
    if (message.isSingleChat) {
      return (isRead ? StrRes.hasRead : StrRes.unread).toText..style = (isRead ? Styles.ts_8E9AB0_12sp : Styles.ts_0089FF_12sp);
    } else {
      if (_needReadMemberCount == 0) return const SizedBox();
      bool isAllRead = _unreadCount <= 0;
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: (isAllRead ? StrRes.allRead : sprintf(StrRes.nPersonUnRead, [_unreadCount])).toText
          ..style = (isAllRead ? Styles.ts_8E9AB0_12sp : Styles.ts_0089FF_12sp),
      );
    }
  }
}
