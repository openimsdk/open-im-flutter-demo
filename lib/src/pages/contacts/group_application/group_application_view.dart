import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'group_application_logic.dart';

class GroupApplicationPage extends StatelessWidget {
  final logic = Get.find<GroupApplicationLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.groupApplicationNotification,
        showShadow: false,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: SafeArea(
        child: Obx(() => ListView.builder(
              itemCount: logic.list.length,
              itemBuilder: (_, index) => _buildItemView(
                logic.list.elementAt(index),
              ),
            )),
      ),
    );
  }

  Widget _buildItemView(GroupApplicationInfo info) => Column(
        children: [
          Container(
            color: PageStyle.c_FFFFFF,
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarView(
                  url: info.userFaceURL,
                ),
                SizedBox(
                  width: 18.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.nickname!,
                        style: PageStyle.ts_333333_16sp,
                      ),
                      RichText(
                        text: TextSpan(
                          text: StrRes.applyJoin,
                          style: PageStyle.ts_666666_12sp,
                          children: [
                            WidgetSpan(
                              child: SizedBox(
                                width: 10.w,
                              ),
                            ),
                            TextSpan(
                              text: logic.getGroupName(info.groupID),
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
                        info.reqMsg!,
                        style: PageStyle.ts_666666_12sp,
                      ),
                    ],
                  ),
                ),
                if (info.handleResult == 0)
                  GestureDetector(
                    onTap: () => logic.handle(info),
                    child: Container(
                      height: 22.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: PageStyle.c_418AE5,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        StrRes.approve,
                        style: PageStyle.ts_418AE5_12sp,
                      ),
                    ),
                  ),
                if (info.handleResult == 1)
                  Text(
                    StrRes.approved,
                    style: PageStyle.ts_418AE5_12sp,
                  ),
                if (info.handleResult == -1)
                  Text(
                    StrRes.rejected,
                    style: PageStyle.ts_898989_12sp,
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 82.w, right: 22.w),
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  color: PageStyle.c_F1F1F1,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      );
}
