import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/avatar_view.dart';
import 'package:openim_enterprise_chat/src/widgets/image_button.dart';
import 'package:openim_enterprise_chat/src/widgets/switch_button.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'chat_setup_logic.dart';

class ChatSetupPage extends StatelessWidget {
  final logic = Get.find<ChatSetupLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle.c_F6F6F6,
      appBar: EnterpriseTitleBar.back(title: StrRes.chatSetup),
      body: Column(
        children: [
          // EnterpriseTitleBar.style4(tile: StrRes.chatSetup),
          SizedBox(height: 6.h),
          Container(
            height: 129.h,
            color: PageStyle.c_FFFFFF,
            padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 20.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AvatarView(
                      size: 58.h,
                      url: logic.icon,
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: 60.w,
                      child: Text(
                        logic.name ?? '',
                        style: PageStyle.ts_666666_18sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                ImageButton(
                  imgStrRes: ImageRes.ic_addBig,
                  imgHeight: 58.h,
                  imgWidth: 58.h,
                  onTap: () => logic.toSelectGroupMember(),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 140.h,
            color: PageStyle.c_FFFFFF,
            padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StrRes.findChatHistory,
                  style: PageStyle.ts_333333_16sp,
                ),
                SizedBox(height: 26.h),
                Row(
                  children: [
                    _buildItemBtn(
                      imgStr: ImageRes.ic_searchHistory,
                      label: StrRes.search,
                    ),
                    _buildItemBtn(
                      imgStr: ImageRes.ic_searchPic,
                      label: StrRes.picture,
                    ),
                    _buildItemBtn(
                      imgStr: ImageRes.ic_searchVideo,
                      label: StrRes.video,
                    ),
                    _buildItemBtn(
                      imgStr: ImageRes.ic_searchFile,
                      label: StrRes.file,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() => _buildItemView(
                label: StrRes.topContacts,
                on: logic.topContacts.value,
                showSwitchBtn: true,
                onClickSwitchBtn: () => logic.toggleTopContacts(),
              )),
          Divider(
            color: Color(0x66999999),
            height: 0.5.h,
          ),
          Obx(() => _buildItemView(
                label: StrRes.notDisturb,
                on: logic.noDisturb.value,
                showSwitchBtn: true,
                onClickSwitchBtn: () => logic.toggleNoDisturb(),
              )),
          SizedBox(height: 12.h),
          _buildItemView(
            label: StrRes.complaint,
            showArrow: true,
          ),
          SizedBox(height: 12.h),
          _buildItemView(
            label: StrRes.clearHistory,
            showArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    bool showArrow = false,
    bool showSwitchBtn = false,
    Function()? onTap,
    bool on = true,
    Function()? onClickSwitchBtn,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          color: PageStyle.c_FFFFFF,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: PageStyle.ts_333333_16sp,
                ),
              ),
              if (showArrow)
                Image.asset(
                  ImageRes.ic_next,
                  width: 10.w,
                  height: 18.h,
                ),
              if (showSwitchBtn)
                SwitchButton(
                  onTap: onClickSwitchBtn,
                  on: on,
                )
            ],
          ),
        ),
      );

  Widget _buildItemBtn({required String imgStr, required String label}) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imgStr,
              width: 22.w,
              height: 18.h,
            ),
            SizedBox(height: 11.h),
            Text(
              label,
              style: PageStyle.ts_666666_12sp,
            ),
          ],
        ),
      );
}
