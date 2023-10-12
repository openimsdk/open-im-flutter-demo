import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatNicknameView extends StatelessWidget {
  const ChatNicknameView({
    Key? key,
    this.nickname,
    this.timeStr,
  }) : super(key: key);
  final String? nickname;
  final String? timeStr;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '',
        style: Styles.ts_8E9AB0_12sp,
        children: [
          if (null != nickname)
            WidgetSpan(
              child: Container(
                constraints: BoxConstraints(maxWidth: 100.w),
                margin: EdgeInsets.only(right: 6.w),
                child: nickname!.toText
                  ..style = Styles.ts_8E9AB0_12sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
            ),
          TextSpan(text: timeStr),
        ],
      ),
    );
  }
}
