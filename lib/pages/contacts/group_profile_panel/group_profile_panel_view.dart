import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'group_profile_panel_logic.dart';

class GroupProfilePanelPage extends StatelessWidget {
  final logic = Get.find<GroupProfilePanelLogic>();

  GroupProfilePanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => Column(
            children: [
              _buildBaseInfo(),
              if (logic.members.isNotEmpty) _buildGroupMemberList(),
              Container(
                height: 56.h,
                color: Styles.c_FFFFFF,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    StrRes.groupID.toText..style = Styles.ts_0C1C33_17sp,
                    12.horizontalSpace,
                    logic.groupInfo.value.groupID.toText
                      ..style = Styles.ts_8E9AB0_17sp,
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: Styles.c_FFFFFF,
                child: Button(
                  text: logic.isJoined.value
                      ? StrRes.enterGroup
                      : StrRes.applyJoin,
                  onTap: logic.enterGroup,
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildBaseInfo() => Container(
        height: 80.h,
        color: Styles.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            AvatarView(
              width: 48.w,
              height: 48.h,
              url: logic.groupInfo.value.faceURL,
              text: logic.groupInfo.value.groupName,
              isGroup: true,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (logic.groupInfo.value.groupName ?? '').toText
                    ..style = Styles.ts_0C1C33_17sp_medium,
                  4.verticalSpace,
                  Row(
                    children: [
                      ImageRes.createGroupTime.toImage
                        ..width = 12.w
                        ..height = 12.h,
                      6.horizontalSpace,
                      DateUtil.formatDateMs(
                        (logic.groupInfo.value.createTime ?? 0),
                        format: IMUtils.getTimeFormat1(),
                      ).toText
                        ..style = Styles.ts_8E9AB0_14sp,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildGroupMemberList() => Container(
        color: Styles.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: StrRes.groupMember,
                style: Styles.ts_0C1C33_17sp,
                children: [
                  WidgetSpan(child: 12.horizontalSpace),
                  TextSpan(
                    text: sprintf(
                        StrRes.nPerson, [logic.groupInfo.value.memberCount]),
                    style: Styles.ts_8E9AB0_17sp,
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6.w,
                childAspectRatio: 1,
              ),
              itemCount: min(logic.members.length, 7),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final member = logic.members.elementAt(index);
                if (index == 6 && logic.members.length != 7) {
                  return ImageRes.moreMembers.toImage
                    ..width = 44.w
                    ..height = 44.h;
                }
                return AvatarView(
                  width: 44.w,
                  height: 44.h,
                  text: member.nickname,
                  url: member.faceURL,
                );
              },
            ),
          ],
        ),
      );
}
