import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';

import 'avatar_view.dart';

enum DialogType {
  FORWARD,
  BASE,
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    this.title,
    this.url,
    this.content,
    this.type = DialogType.BASE,
    this.rightText,
  }) : super(key: key);
  final String? title;
  final String? url;
  final String? content;
  final DialogType type;
  final String? rightText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 249.w,
            color: PageStyle.c_FFFFFF,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (type == DialogType.FORWARD)
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.w, 18.h, 0, 19.h),
                        child: Text(
                          title ?? '',
                          style: PageStyle.ts_333333_16sp,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 25.w),
                          AvatarView(
                            url: url,
                            size: 34.h,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            content ?? '',
                            style: PageStyle.ts_333333_16sp,
                          )
                        ],
                      ),
                    ],
                  ),
                if (type == DialogType.BASE)
                  Padding(
                    padding: EdgeInsets.only(top: 22.h, left: 8.w, right: 8.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title ?? '',
                            style: PageStyle.ts_333333_16sp,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 21.h,
                ),
                Divider(
                  color: PageStyle.c_979797_opacity50p,
                  height: 0.5.h,
                ),
                Row(
                  children: [
                    _button(
                      bgColor: PageStyle.c_FFFFFF,
                      text: StrRes.cancel,
                      textStyle: PageStyle.ts_333333_16sp,
                      onTap: () {
                        Get.back(result: false);
                      },
                    ),
                    Container(
                      color: PageStyle.c_979797_opacity50p,
                      width: 0.5.w,
                      height: 46.h,
                    ),
                    _button(
                      bgColor: PageStyle.c_E8F2FF,
                      text: rightText ?? StrRes.sure,
                      textStyle: PageStyle.ts_1B72EC_16sp,
                      onTap: () {
                        Get.back(result: true);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _button({
    required Color bgColor,
    required String text,
    required TextStyle textStyle,
    Function()? onTap,
  }) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(6),
              color: bgColor,
            ),
            height: 46.h,
            alignment: Alignment.center,
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
      );
}
