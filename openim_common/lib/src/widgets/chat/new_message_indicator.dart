import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class NewMessageIndicator extends StatelessWidget {
  const NewMessageIndicator({
    Key? key,
    this.newMessageCount = 0,
    this.onTap,
  }) : super(key: key);
  final int newMessageCount;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
          constraints: BoxConstraints(minHeight: 31.h),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Styles.c_E8EAEF, width: 1),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 6.h),
                blurRadius: 16.r,
                spreadRadius: 1.r,
                color: Styles.c_8E9AB0_opacity16,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageRes.scrollDown.toImage
                ..width = 16.w
                ..height = 16.h,
              4.horizontalSpace,
              sprintf(StrRes.nMessage, [newMessageCount]).toText
                ..style = Styles.ts_0089FF_12sp,
            ],
          ),
        ),
      ),
    );
  }
}
