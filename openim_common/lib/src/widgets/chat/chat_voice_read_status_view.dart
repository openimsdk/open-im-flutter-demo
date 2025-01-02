import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatVoiceReadStatusView extends StatelessWidget {
  const ChatVoiceReadStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: 6.w,
        height: 6.w,
        decoration: BoxDecoration(
          color: Styles.c_FF381F,
          shape: BoxShape.circle,
        ),
      );
}
