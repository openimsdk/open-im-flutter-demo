import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/switch_button.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'friend_info_logic.dart';

class FriendInfoPage extends StatelessWidget {
  final logic = Get.find<FriendInfoLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(),
      backgroundColor: PageStyle.c_F6F6F6,
      body: SingleChildScrollView(
        child: Container(
          height: 728.h,
          child: Obx(
            () => Column(
              children: [
                Container(
                  height: 127.h,
                  color: PageStyle.c_FFFFFF,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 40.h,
                        left: 22.w,
                        child: Text(
                          logic.info.value.getShowName(),
                          style: PageStyle.ts_333333_24sp,
                        ),
                      ),
                      Positioned(
                        top: 20.h,
                        right: 22.w,
                        child: AvatarView(
                          size: 72.h,
                          url: logic.info.value.faceURL,
                          enabledPreview: true,
                        ),
                      )
                    ],
                  ),
                ),
                _buildLine(),
                _buildItemView(
                  label: StrRes.idCode,
                  onTap: () => logic.toCopyId(),
                  showArrowBtn: true,
                ),
                if (logic.info.value.isFriendship == true)
                  Column(
                    children: [
                      _buildLine(),
                      _buildItemView(
                        label: StrRes.remark,
                        onTap: () => logic.toSetupRemark(),
                        showArrowBtn: true,
                      ),
                      _buildLine(),
                      _buildItemView(
                        label: StrRes.personalInfo,
                        onTap: () => logic.viewPersonalInfo(),
                        showArrowBtn: true,
                      ),
                      _buildLine(),
                      _buildItemView(
                        label: StrRes.recommendToFriends,
                        onTap: () => logic.recommendFriend(),
                        showArrowBtn: true,
                      ),
                      _buildLine(),
                      _buildItemView(
                        label: StrRes.addBlacklist,
                        showSwitchBtn: true,
                        switchOn: logic.info.value.isBlacklist == true,
                        onTap: () => logic.toggleBlacklist(),
                      ),
                      SizedBox(
                        height: 58.h,
                      ),
                      _buildItemView(
                        label: StrRes.relieveRelationship,
                        alignment: Alignment.center,
                        style: PageStyle.ts_D9350D_18sp,
                        onTap: () => logic.deleteFromFriendList(),
                      ),
                    ],
                  ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBtn(
                      icon: ImageRes.ic_sendMsg,
                      label: StrRes.sendMsg,
                      style: PageStyle.ts_1D6BED_14sp,
                      onTap: () => logic.toChat(),
                    ),
                    _buildBtn(
                      icon: ImageRes.ic_appCall,
                      label: StrRes.appCall,
                      style: PageStyle.ts_1D6BED_14sp,
                      onTap: () => logic.toCall(),
                    ),
                    // _buildBtn(
                    //   icon: logic.info.value.isFriendship
                    //       ? ImageRes.ic_sendMsg
                    //       : ImageRes.ic_sendMsgGrey,
                    //   label: StrRes.sendMsg,
                    //   style: logic.info.value.isFriendship
                    //       ? PageStyle.ts_1D6BED_14sp
                    //       : PageStyle.ts_B8B8B8_14sp,
                    //   onTap: () => logic.toChat(),
                    // ),
                    // _buildBtn(
                    //   icon: logic.info.value.isFriendship
                    //       ? ImageRes.ic_appCall
                    //       : ImageRes.ic_appCallGrey,
                    //   label: StrRes.appCall,
                    //   style: logic.info.value.isFriendship
                    //       ? PageStyle.ts_1D6BED_14sp
                    //       : PageStyle.ts_B8B8B8_14sp,
                    //   onTap: () => logic.toCall(),
                    // ),
                    if (logic.info.value.isFriendship == false)
                      _buildBtn(
                        icon: ImageRes.ic_sendAddFriendMsg,
                        label: StrRes.addFriend,
                        style: PageStyle.ts_1D6BED_14sp,
                        onTap: () => logic.addFriend(),
                      ),
                  ],
                ),
                SizedBox(
                  height: 94.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBtn({
    required String icon,
    required String label,
    required TextStyle style,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 50.w,
              height: 50.h,
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              label,
              style: style,
            ),
          ],
        ),
      );

  Widget _buildItemView({
    required String label,
    TextStyle? style,
    AlignmentGeometry alignment = Alignment.centerLeft,
    Function()? onTap,
    bool showArrowBtn = false,
    bool showSwitchBtn = false,
    bool switchOn = false,
  }) =>
      Ink(
        color: PageStyle.c_FFFFFF,
        height: 55.h,
        child: InkWell(
          onTap: showSwitchBtn ? null : onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            alignment: alignment,
            child: showArrowBtn || showSwitchBtn
                ? Row(
                    children: [
                      Text(
                        label,
                        style: style ?? PageStyle.ts_333333_18sp,
                      ),
                      Spacer(),
                      if (showArrowBtn)
                        Image.asset(
                          ImageRes.ic_next,
                          width: 7.w,
                          height: 13.h,
                        ),
                      if (showSwitchBtn)
                        SwitchButton(
                          width: 51.w,
                          height: 31.h,
                          on: switchOn,
                          onTap: onTap,
                        ),
                    ],
                  )
                : Text(
                    label,
                    style: style ?? PageStyle.ts_333333_18sp,
                  ),
          ),
        ),
      );

  Widget _buildLine() => Container(
        height: 0.5,
        color: PageStyle.c_999999_opacity40p,
      );
}
