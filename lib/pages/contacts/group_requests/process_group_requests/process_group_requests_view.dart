import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'process_group_requests_logic.dart';

class ProcessGroupRequestsPage extends StatelessWidget {
  final logic = Get.find<ProcessGroupRequestsLogic>();

  ProcessGroupRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.newGroup),
      backgroundColor: Styles.c_F8F9FA,
      body: Container(
        color: Styles.c_FFFFFF,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AvatarView(
                  width: 48.w,
                  height: 48.h,
                  url: logic.applicationInfo.userFaceURL,
                  text: logic.applicationInfo.nickname,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (logic.applicationInfo.nickname ?? '').toText..style = Styles.ts_0C1C33_17sp,
                    RichText(
                      text: TextSpan(
                        text: StrRes.applyJoin,
                        style: Styles.ts_8E9AB0_14sp,
                        children: [
                          WidgetSpan(child: 2.horizontalSpace),
                          TextSpan(
                            text: logic.groupName,
                            style: Styles.ts_0089FF_14sp,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            12.verticalSpace,
            if (IMUtils.isNotNullEmptyStr(logic.applicationInfo.reqMsg))
              Container(
                height: 80.h,
                width: 343.w,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Styles.c_E8EAEF_opacity50,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (logic.applicationInfo.reqMsg ?? '').toText..style = Styles.ts_0C1C33_17sp,
                    ],
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                sprintf(StrRes.sourceFrom, [logic.sourceFrom]).toText..style = Styles.ts_8E9AB0_14sp
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Flexible(child: _buildRejectButton()),
                12.horizontalSpace,
                Flexible(
                  child: Button(
                    onTap: logic.approve,
                    text: StrRes.accept,
                    textStyle: Styles.ts_FFFFFF_17sp,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRejectButton() => Material(
        child: Ink(
          height: 44.h,
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            border: Border.all(
              color: Styles.c_E8EAEF,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: InkWell(
            onTap: logic.reject,
            child: Container(
              alignment: Alignment.center,
              child: StrRes.reject.toText..style = Styles.ts_0C1C33_17sp,
            ),
          ),
        ),
      );
}
