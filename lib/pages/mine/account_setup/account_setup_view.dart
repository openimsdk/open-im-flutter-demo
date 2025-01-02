import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'account_setup_logic.dart';

class AccountSetupPage extends StatelessWidget {
  final logic = Get.find<AccountSetupLogic>();

  AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.accountSetup,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              children: [
                10.verticalSpace,
                _buildItemView(
                  label: StrRes.notDisturbMode,
                  switchOn: logic.isGlobalNotDisturb,
                  onChanged: (_) => logic.toggleNotDisturbMode(),
                  showSwitchButton: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  label: StrRes.allowRing,
                  switchOn: logic.isAllowBeep,
                  onChanged: (_) => logic.toggleBeep(),
                  showSwitchButton: true,
                ),
                _buildItemView(
                  label: StrRes.allowVibrate,
                  switchOn: logic.isAllowVibration,
                  onChanged: (_) => logic.toggleVibration(),
                  showSwitchButton: true,
                  isBottomRadius: true,
                ),
                10.verticalSpace,
                _buildItemView(
                  label: StrRes.forbidAddMeToFriend,
                  switchOn: !logic.isAllowAddFriend,
                  onChanged: (_) => logic.toggleForbidAddMeToFriend(),
                  showSwitchButton: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  label: StrRes.blacklist,
                  onTap: logic.blacklist,
                  showRightArrow: true,
                ),
                _buildItemView(
                  label: StrRes.languageSetup,
                  value: logic.curLanguage.value,
                  onTap: logic.languageSetting,
                  showRightArrow: true,
                  isBottomRadius: true,
                ),
                10.verticalSpace,
                _buildItemView(
                  label: StrRes.unlockSettings,
                  onTap: logic.unlockSetup,
                  showRightArrow: true,
                  isTopRadius: true,
                ),
                _buildItemView(
                  label: StrRes.changePassword,
                  showRightArrow: true,
                  onTap: logic.changePwd,
                ),
                _buildItemView(
                  label: StrRes.clearChatHistory,
                  textStyle: Styles.ts_FF381F_17sp,
                  onTap: logic.clearChatHistory,
                  showRightArrow: true,
                  isBottomRadius: true,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildItemView({
    required String label,
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
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Ink(
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(isTopRadius ? 6.r : 0),
              topLeft: Radius.circular(isTopRadius ? 6.r : 0),
              bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
              bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  label.toText..style = textStyle ?? Styles.ts_0C1C33_17sp,
                  const Spacer(),
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
          ),
        ),
      );
}
