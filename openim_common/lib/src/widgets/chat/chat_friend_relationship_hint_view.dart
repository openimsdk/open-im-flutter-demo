import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatFriendRelationshipAbnormalHintView extends StatelessWidget {
  const ChatFriendRelationshipAbnormalHintView({
    Key? key,
    this.blockedByFriend = false,
    this.deletedByFriend = false,
    required this.name,
    this.onTap,
  }) : super(key: key);
  final bool blockedByFriend;
  final bool deletedByFriend;
  final String name;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (blockedByFriend) {
      return StrRes.blockedByFriendHint.toText..style = Styles.ts_8E9AB0_12sp;
    } else if (deletedByFriend) {
      return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: RichText(
          text: TextSpan(
            text: sprintf(StrRes.deletedByFriendHint, [name]),
            style: Styles.ts_8E9AB0_12sp,
            children: [
              TextSpan(
                text: StrRes.sendFriendVerification,
                style: Styles.ts_0089FF_12sp,
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
