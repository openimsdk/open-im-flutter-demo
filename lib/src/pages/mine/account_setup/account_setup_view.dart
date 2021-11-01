import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/images.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/switch_button.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'account_setup_logic.dart';

class AccountSetupPage extends StatelessWidget {
  final logic = Get.find<AccountSetupLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.accountSetup,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Column(
        children: [
          SizedBox(
            height: 12.h,
          ),
          Obx(() => _buildItemView(
                label: StrRes.notDisturbModel,
                showSwitchBtn: true,
                switchOn: logic.notDisturbModel.value,
                onTap: () => logic.toggleNotDisturbModel(),
              )),
          _buildItemView(
            label: StrRes.addMyMethod,
            onTap: () => logic.setAddMyMethod(),
          ),
          _buildItemView(
            label: StrRes.blacklist,
            onTap: () => logic.blacklist(),
          )
        ],
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    Function()? onTap,
    bool showSwitchBtn = false,
    bool switchOn = false,
  }) =>
      Ink(
        height: 58.h,
        color: PageStyle.c_FFFFFF,
        child: InkWell(
          onTap: showSwitchBtn ? null : onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  color: PageStyle.c_999999_opacity40p,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: PageStyle.ts_333333_18sp,
                ),
                Spacer(),
                if (showSwitchBtn)
                  SwitchButton(
                    width: 42.w,
                    height: 25.h,
                    on: switchOn,
                    onTap: onTap,
                  ),
                if (!showSwitchBtn)
                  Image.asset(
                    ImageRes.ic_next,
                    width: 10.w,
                    height: 17.h,
                  ),
              ],
            ),
          ),
        ),
      );
}
