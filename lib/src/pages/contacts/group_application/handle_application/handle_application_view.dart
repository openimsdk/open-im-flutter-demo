import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/image_button.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'handle_application_logic.dart';

class HandleGroupApplicationPage extends StatelessWidget {
  final logic = Get.find<HandleGroupApplicationLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        showShadow: false,
        title: StrRes.groupApplicationNotification,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Column(
        children: [
          Container(
            color: PageStyle.c_FFFFFF,
            padding: EdgeInsets.only(
              left: 22.w,
              right: 22.w,
              top: 37.h,
              bottom: 21.h,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    AvatarView(
                      size: 48.h,
                      url: logic.aInfo.userFaceURL,
                    ),
                    SizedBox(
                      width: 22.w,
                    ),
                    Expanded(
                      child: Text(
                        logic.aInfo.nickname!,
                        style: PageStyle.ts_333333_20sp,
                      ),
                    ),
                    ImageButton(
                      imgStrRes: ImageRes.ic_next,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ],
                ),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.only(top: 33.h),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 18.w,
                  ),
                  decoration: BoxDecoration(
                    color: PageStyle.c_EEEEEE,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: StrRes.applyJoin,
                          style: PageStyle.ts_333333_12sp,
                          children: [
                            WidgetSpan(
                              child: SizedBox(
                                width: 10.w,
                              ),
                            ),
                            TextSpan(
                              text: logic.gInfo.groupName,
                              style: PageStyle.ts_418AE5_12sp,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Text(
                        StrRes.applyReason,
                        style: PageStyle.ts_666666_12sp,
                      ),
                      Text(
                        logic.aInfo.reqMsg!,
                        style: PageStyle.ts_666666_12sp,
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Text(
                        StrRes.reply,
                        style: PageStyle.ts_1B61D6_16sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Ink(
            height: 55.h,
            color: PageStyle.c_FFFFFF,
            child: InkWell(
              onTap: logic.approve,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  StrRes.passGroupApplication,
                  style: PageStyle.ts_1B61D6_18sp,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Ink(
            height: 55.h,
            color: PageStyle.c_FFFFFF,
            child: InkWell(
              onTap: logic.reject,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  StrRes.rejectGroupApplication,
                  style: PageStyle.ts_999999_18sp,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120.h),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StrRes.addBlacklist,
                  style: PageStyle.ts_1D6BED_14sp,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 20.h,
                  width: 1,
                  color: PageStyle.c_1D6BED,
                ),
                Text(
                  StrRes.complaint,
                  style: PageStyle.ts_1D6BED_14sp,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
