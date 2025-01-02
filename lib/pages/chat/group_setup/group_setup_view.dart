import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'group_setup_logic.dart';

class GroupSetupPage extends StatelessWidget {
  final logic = Get.find<GroupSetupLogic>();

  GroupSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.groupChatSetup),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                if (logic.isJoinedGroup.value) _buildBaseInfoView(),
                if (logic.isJoinedGroup.value) _buildMemberView(),
                if (logic.isOwner)
                  _buildItemView(
                    text: StrRes.groupManage,
                    showRightArrow: true,
                    isBottomRadius: true,
                    onTap: logic.groupManage,
                  ),
                  10.verticalSpace,
       
                _buildItemView(
                  text: StrRes.messageNotDisturb,
                  switchOn: logic.isNotDisturb,
                  showSwitchButton: true,
                  isBottomRadius: true,
                  onChanged: (_) => logic.toggleNotDisturb(),
                ),
                10.verticalSpace,
                _buildItemView(
                  text: StrRes.clearChatHistory,
                  textStyle: Styles.ts_FF381F_17sp,
                  isTopRadius: true,
                  showRightArrow: true,
                  onTap: logic.clearChatHistory,
                ),
                if (!logic.isOwner)
                  _buildItemView(
                    text: logic.isJoinedGroup.value ? StrRes.exitGroup : StrRes.delete,
                    textStyle: Styles.ts_FF381F_17sp,
                    showRightArrow: true,
                    onTap: logic.quitGroup,
                  ),
                if (logic.isOwner)
                  _buildItemView(
                    text: StrRes.dismissGroup,
                    textStyle: Styles.ts_FF381F_17sp,
                    isBottomRadius: true,
                    showRightArrow: true,
                    onTap: logic.quitGroup,
                  ),
                40.verticalSpace,
              ],
            ),
          )),
    );
  }

  Widget _buildBaseInfoView() => Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50.h,
              height: 50.h,
              child: Stack(
                children: [
                  AvatarView(
                    width: 48.w,
                    height: 48.h,
                    url: logic.groupInfo.value.faceURL,
                    file: logic.avatar.value,
                    text: logic.groupInfo.value.groupName,
                    textStyle: Styles.ts_FFFFFF_14sp,
                    isGroup: true,
                    onTap: logic.isOwnerOrAdmin ? logic.modifyGroupAvatar : null,
                  ),
                  if (logic.isOwnerOrAdmin)
                    Align(
                        alignment: Alignment.bottomRight,
                        child: ImageRes.editAvatar.toImage
                          ..width = 14.w
                          ..height = 14.h)
                ],
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: logic.isOwnerOrAdmin ? () => logic.modifyGroupName(logic.conversationInfo.value.faceURL) : null,
                    child: Row(
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200.w),
                            child: (logic.groupInfo.value.groupName ?? '').toText..style = Styles.ts_0C1C33_17sp),
                        '(${logic.groupInfo.value.memberCount ?? 0})'.toText..style = Styles.ts_0C1C33_17sp,
                        6.horizontalSpace,
                        if (logic.isOwnerOrAdmin)
                          ImageRes.editName.toImage
                            ..width = 12.w
                            ..height = 12.h,
                      ],
                    ),
                  ),
                  4.verticalSpace,
                  logic.groupInfo.value.groupID.toText
                    ..style = Styles.ts_8E9AB0_14sp
                    ..onTap = logic.copyGroupID,
                ],
              ),
            ),
            ImageRes.mineQr.toImage
              ..width = 18.w
              ..height = 18.h
              ..onTap = logic.viewGroupQrcode,
          ],
        ),
      );

  Widget _buildMemberView() => Container(
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.circular(6.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logic.length(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 68.w / 78.h,
              ),
              itemBuilder: (BuildContext context, int index) {
                return logic.itemBuilder(
                  index: index,
                  builder: (info) => Column(
                    children: [
                      SizedBox(
                        width: 58.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AvatarView(
                              width: 48.w,
                              height: 48.h,
                              url: info.faceURL,
                              text: info.nickname,
                              textStyle: Styles.ts_FFFFFF_14sp,
                              onTap: () => logic.viewMemberInfo(info),
                            ),
                            if (logic.groupInfo.value.ownerUserID == info.userID)
                              Positioned(
                                bottom: 0.h,
                                child: Container(
                                  width: 52.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Styles.c_E8EAEF,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: StrRes.groupOwner.toText
                                    ..style = Styles.ts_8E9AB0_10sp
                                    ..maxLines = 1
                                    ..overflow = TextOverflow.ellipsis,
                                ),
                              )
                          ],
                        ),
                      ),
                      2.verticalSpace,
                      (info.nickname ?? '').toText
                        ..style = Styles.ts_8E9AB0_10sp
                        ..maxLines = 1
                        ..overflow = TextOverflow.ellipsis,
                    ],
                  ),
                  addButton: () => GestureDetector(
                    onTap: logic.addMember,
                    child: Column(
                      children: [
                        ImageRes.addMember.toImage
                          ..width = 48.w
                          ..height = 48.h,
                        StrRes.addMember.toText..style = Styles.ts_8E9AB0_10sp,
                      ],
                    ),
                  ),
                  delButton: () => GestureDetector(
                    onTap: logic.removeMember,
                    child: Column(
                      children: [
                        ImageRes.delMember.toImage
                          ..width = 48.w
                          ..height = 48.h,
                        StrRes.delMember.toText..style = Styles.ts_8E9AB0_10sp,
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              color: Styles.c_E8EAEF,
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: logic.viewGroupMembers,
              child: Container(
                padding: EdgeInsets.only(left: 12.w, right: 16.w),
                height: 46.h,
                child: Row(
                  children: [
                    sprintf(StrRes.viewAllGroupMembers, [logic.groupInfo.value.memberCount]).toText
                      ..style = Styles.ts_0C1C33_17sp,
                    const Spacer(),
                    ImageRes.rightArrow.toImage
                      ..width = 24.w
                      ..height = 24.h,
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildItemView({
    required String text,
    TextStyle? textStyle,
    String? value,
    bool switchOn = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 46.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(isTopRadius ? 6.r : 0),
              topLeft: Radius.circular(isTopRadius ? 6.r : 0),
              bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
              bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                  child: text.toText
                    ..style = textStyle ?? Styles.ts_0C1C33_17sp
                    ..maxLines = 1),
              if (null != value)
                value.toText
                  ..style = Styles.ts_8E9AB0_14sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              if (showSwitchButton)
                CupertinoSwitch(
                  value: switchOn,
                  activeColor: Styles.c_0089FF,
                  onChanged: onChanged,
                ),
              if (showRightArrow)
                ImageRes.rightArrow.toImage
                  ..width = 24.w
                  ..height = 24.h,
            ],
          ),
        ),
      );
}
