import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'user_profile _panel_logic.dart';

class UserProfilePanelPage extends StatelessWidget {
  final logic = Get.find<UserProfilePanelLogic>(tag: GetTags.userProfile);

  UserProfilePanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: TitleBar.back(
          right: logic.isFriendship
              ? (ImageRes.moreBlack.toImage
                ..width = 24.w
                ..height = 24.h
                ..onTap = logic.friendSetup)
              : null,
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: SizedBox(
          height: 1.sh,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBaseInfoView(),
                    if (logic.isGroupMemberPage) _buildEnterGroupMethodView(),
                    if (logic.isFriendship ||
                        logic.isMyself ||
                        logic.isGroupMemberPage && !logic.notAllowLookGroupMemberProfiles.value)
                      _buildItemView(
                        label: StrRes.personalInfo,
                        showRightArrow: true,
                        onTap: logic.viewPersonalInfo,
                      ),
                    SizedBox(height: 108.h),
                  ],
                ),
              ),
              if ((logic.isFriendship || logic.allowSendMsgNotFriend) && !logic.isMyself) _buildButtonGroup(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBaseInfoView() => Container(
        color: Styles.c_FFFFFF,
        height: 80.h,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            AvatarView(
              url: logic.userInfo.value.faceURL,
              text: logic.userInfo.value.nickname,
              width: 48.w,
              height: 48.h,
              textStyle: Styles.ts_FFFFFF_14sp,
              enabledPreview: true,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logic.getShowName().toText
                    ..style = Styles.ts_0C1C33_17sp_medium
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
                  if (!logic.isGroupMemberPage || logic.isGroupMemberPage && !logic.notAllowAddGroupMemberFriend.value)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: (logic.userInfo.value.userID ?? '').toText
                        ..style = Styles.ts_8E9AB0_14sp
                        ..onTap = logic.copyID,
                    ),
                ],
              ),
            ),
            if (!logic.isMyself &&
                logic.isAllowAddFriend &&
                !logic.isFriendship &&
                (!logic.isGroupMemberPage ||
                    logic.forceCanAdd == true ||
                    logic.isGroupMemberPage && !logic.notAllowAddGroupMemberFriend.value))
              Material(
                child: Ink(
                  decoration: BoxDecoration(
                    color: Styles.c_0089FF,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: InkWell(
                    onTap: logic.addFriend,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 4.h,
                      ),
                      child: Row(
                        children: [
                          ImageRes.addContacts.toImage
                            ..width = 21.w
                            ..height = 21.h
                            ..color = Styles.c_FFFFFF,
                          2.horizontalSpace,
                          StrRes.add.toText..style = Styles.ts_FFFFFF_14sp,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _buildEnterGroupMethodView() {
    if (logic.joinGroupTime.value == 0 && logic.joinGroupMethod.value.isEmpty) {
      return Container();
    }
    return Container(
      color: Styles.c_FFFFFF,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        columnWidths: {0: FixedColumnWidth(100.w)},
        children: [
          if (logic.joinGroupTime.value > 0)
            _buildTabRowView(
              label: StrRes.joinGroupDate,
              value: DateUtil.formatDateMs(
                logic.joinGroupTime.value,
                format: DateFormats.zh_y_mo_d,
              ),
            ),
          if (logic.joinGroupMethod.value.isNotEmpty)
            _buildTabRowView(
              label: StrRes.joinGroupMethod,
              value: logic.joinGroupMethod.value,
            ),
        ],
      ),
    );
  }

  TableRow _buildTabRowView({
    required String label,
    String? value,
  }) =>
      TableRow(
        children: [
          TableCell(
            child: Container(
              constraints: BoxConstraints(minHeight: 40.h),
              alignment: Alignment.centerLeft,
              child: label.toText..style = Styles.ts_8E9AB0_17sp,
            ),
          ),
          TableCell(
            child: Container(
              constraints: BoxConstraints(minHeight: 40.h),
              alignment: Alignment.centerLeft,
              child: (value ?? '').toText..style = Styles.ts_0C1C33_17sp,
            ),
          ),
        ],
      );

  Widget _buildItemView({
    required String label,
    String? value,
    bool addMargin = false,
    bool showSwitchButton = false,
    bool showRightArrow = false,
    bool switchOn = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      Container(
        margin: EdgeInsets.only(bottom: addMargin ? 10.h : 0),
        child: Ink(
          color: Styles.c_FFFFFF,
          height: 56.h,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  label.toText..style = Styles.ts_0C1C33_17sp,
                  const Spacer(),
                  if (showSwitchButton)
                    CupertinoSwitch(
                      value: switchOn,
                      activeColor: Styles.c_0089FF,
                      onChanged: onChanged,
                    ),
                  if (null != value) value.toText..style = Styles.ts_0C1C33_17sp,
                  if (showRightArrow)
                    ImageRes.rightArrow.toImage
                      ..width = 24.w
                      ..height = 24.h,
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildButtonGroup() => Positioned(
        bottom: 0.h,
        width: 1.sw,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Styles.c_F8F9FA.withOpacity(.3),
              padding: EdgeInsets.symmetric(horizontal: 9.w),
              height: 108.h,
              child: Row(
                children: [
                  Expanded(
                    child: ImageTextButton.call(
                      onTap: logic.toCall,
                    ),
                  ),
                  11.horizontalSpace,
                  Expanded(
                    child: ImageTextButton.message(
                      onTap: logic.toChat,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
