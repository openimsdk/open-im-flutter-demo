import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatTimelineView extends StatelessWidget {
  const ChatTimelineView({
    Key? key,
    required this.timeStr,
    this.margin,
  }) : super(key: key);
  final String timeStr;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Styles.c_F4F5F7,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: timeStr.toText..style = Styles.ts_8E9AB0_12sp,
    );
  }
}
