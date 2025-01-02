import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'group_requests_logic.dart';

class GroupRequestsPage extends StatelessWidget {
  final logic = Get.find<GroupRequestsLogic>();

  GroupRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.newGroupRequest),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => ListView.builder(
            padding: EdgeInsets.only(top: 10.h),
            itemCount: logic.list.length,
            itemBuilder: (_, index) => _buildItemView(logic.list[index]),
          )),
    );
  }

  Widget _buildItemView(GroupApplicationInfo info) {
    final isISendRequest = info.userID == OpenIM.iMManager.userID;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: BorderDirectional(
          bottom: BorderSide(color: Styles.c_F8F9FA, width: 1.h),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarView(
                  url: info.userFaceURL,
                  text: info.nickname,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (info.nickname ?? '').toText
                        ..style = Styles.ts_0C1C33_17sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                      4.verticalSpace,
                      if (!logic.isInvite(info))
                        RichText(
                          text: TextSpan(
                            text: StrRes.applyJoin,
                            style: Styles.ts_8E9AB0_14sp,
                            children: [
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: logic.getGroupName(info),
                                style: Styles.ts_0089FF_14sp,
                              ),
                            ],
                          ),
                        )
                      else
                        RichText(
                          text: TextSpan(
                            text: logic.getInviterNickname(info),
                            style: Styles.ts_0089FF_14sp,
                            children: [
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: StrRes.invite,
                                style: Styles.ts_8E9AB0_14sp,
                              ),
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: info.nickname,
                                style: Styles.ts_0089FF_14sp,
                              ),
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: StrRes.joinIn,
                                style: Styles.ts_8E9AB0_14sp,
                              ),
                              WidgetSpan(child: 2.horizontalSpace),
                              TextSpan(
                                text: logic.getGroupName(info),
                                style: Styles.ts_0089FF_14sp,
                              ),
                            ],
                          ),
                        ),
                      if (null != IMUtils.emptyStrToNull(info.reqMsg))
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: sprintf(StrRes.applyReason, [info.reqMsg!]).toText
                            ..style = Styles.ts_8E9AB0_14sp
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (/*info.handleResult == 0 && */ isISendRequest)
            ImageRes.sendRequests.toImage
              ..width = 20.w
              ..height = 20.h,
          if (info.handleResult == 0 && !isISendRequest)
            Button(
              text: StrRes.lookOver,
              textStyle: Styles.ts_FFFFFF_14sp,
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              onTap: () => logic.handle(info),
            ),
          if (info.handleResult == 0 && isISendRequest)
            StrRes.waitingForVerification.toText..style = Styles.ts_8E9AB0_14sp,
          if (info.handleResult == -1) StrRes.rejected.toText..style = Styles.ts_8E9AB0_14sp,
          if (info.handleResult == 1) StrRes.approved.toText..style = Styles.ts_8E9AB0_14sp,
        ],
      ),
    );
  }
}
