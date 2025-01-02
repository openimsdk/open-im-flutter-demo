import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'change_pwd_logic.dart';

class ChangePwdPage extends StatelessWidget {
  final logic = Get.find<ChangePwdLogic>();

  ChangePwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        appBar: TitleBar.back(
          title: StrRes.changePassword,
          right: StrRes.determine.toText
            ..style = Styles.ts_0C1C33_17sp
            ..onTap = logic.confirm,
        ),
        backgroundColor: Styles.c_F8F9FA,
        body: SingleChildScrollView(
          child: Column(
            children: [
              12.verticalSpace,
              _buildItemView(
                label: StrRes.oldPwd,
                controller: logic.oldPwdCtrl,
                autofocus: true,
                isTopRadius: true,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.newPwd,
                controller: logic.newPwdCtrl,
              ),
              Container(
                margin: EdgeInsets.only(left: 26.w, right: 10.w),
                color: Styles.c_E8EAEF,
                height: .5,
              ),
              _buildItemView(
                label: StrRes.confirmNewPwd,
                controller: logic.againPwdCtrl,
                isBottomRadius: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    TextEditingController? controller,
    bool autofocus = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
  }) =>
      Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Styles.c_FFFFFF,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTopRadius ? 6.r : 0),
            topRight: Radius.circular(isTopRadius ? 6.r : 0),
            bottomRight: Radius.circular(isBottomRadius ? 6.r : 0),
            bottomLeft: Radius.circular(isBottomRadius ? 6.r : 0),
          ),
        ),
        child: Row(
          children: [
            label.toText..style = Styles.ts_0C1C33_17sp,
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: autofocus,
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.end,
                style: Styles.ts_0C1C33_17sp,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );
}
