import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

enum DialogType {
  confirm,
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    this.title,
    this.url,
    this.content,
    this.rightText,
    this.leftText,
    this.onTapLeft,
    this.onTapRight,
  }) : super(key: key);
  final String? title;
  final String? url;
  final String? content;
  final String? rightText;
  final String? leftText;
  final Function()? onTapLeft;
  final Function()? onTapRight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            width: 280.w,
            color: Styles.c_FFFFFF,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: Text(
                    title ?? '',
                    style: Styles.ts_0C1C33_17sp,
                  ),
                ),
                Divider(
                  color: Styles.c_E8EAEF,
                  height: 0.5.h,
                ),
                Row(
                  children: [
                    _button(
                      bgColor: Styles.c_FFFFFF,
                      text: leftText ?? StrRes.cancel,
                      textStyle: Styles.ts_0C1C33_17sp,
                      onTap: onTapLeft ?? () => Get.back(result: false),
                    ),
                    Container(
                      color: Styles.c_E8EAEF,
                      width: 0.5.w,
                      height: 48.h,
                    ),
                    _button(
                      bgColor: Styles.c_FFFFFF,
                      text: rightText ?? StrRes.determine,
                      textStyle: Styles.ts_0089FF_17sp,
                      onTap: onTapRight ?? () => Get.back(result: true),
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
              color: bgColor,
            ),
            height: 48.h,
            alignment: Alignment.center,
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
      );
}

class ForwardHintDialog extends StatelessWidget {
  const ForwardHintDialog({
    Key? key,
    required this.title,
    this.checkedList = const [],
  }) : super(key: key);
  final String title;
  final List<dynamic> checkedList;

  @override
  Widget build(BuildContext context) {
    final list = IMUtils.convertCheckedListToForwardObj(checkedList);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            margin: EdgeInsets.symmetric(horizontal: 36.w),
            decoration: BoxDecoration(
              color: Styles.c_FFFFFF,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                (list.length == 1 ? StrRes.sentTo : StrRes.sentSeparatelyTo).toText
                  ..style = Styles.ts_0C1C33_17sp_medium,
                5.verticalSpace,
                list.length == 1
                    ? Row(
                        children: [
                          AvatarView(
                            url: list.first['faceURL'],
                            text: list.first['nickname'],
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: (list.first['nickname'] ?? '').toText
                              ..style = Styles.ts_0C1C33_17sp
                              ..maxLines = 1
                              ..overflow = TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 120.h),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 0,
                            childAspectRatio: 50.w / 65.h,
                          ),
                          itemCount: list.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) => Column(
                            children: [
                              AvatarView(
                                url: list.elementAt(index)['faceURL'],
                                text: list.elementAt(index)['nickname'],
                              ),
                              10.horizontalSpace,
                              (list.elementAt(index)['nickname'] ?? '').toText
                                ..style = Styles.ts_8E9AB0_10sp
                                ..maxLines = 1
                                ..overflow = TextOverflow.ellipsis,
                            ],
                          ),
                        ),
                      ),
                5.verticalSpace,
                title.toText
                  ..style = Styles.ts_8E9AB0_14sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StrRes.cancel.toText
                      ..style = Styles.ts_0C1C33_17sp
                      ..onTap = () => Get.back(),
                    26.horizontalSpace,
                    StrRes.determine.toText
                      ..style = Styles.ts_0089FF_17sp
                      ..onTap = () => Get.back(result: true),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
