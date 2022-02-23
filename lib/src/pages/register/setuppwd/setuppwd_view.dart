import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/pwd_input_box.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import 'setuppwd_logic.dart';

class SetupPwdPage extends StatelessWidget {
  final logic = Get.find<SetupPwdLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: PageStyle.c_FFFFFF,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 152.h),
                Text(
                  StrRes.plsSetupPwd,
                  style: PageStyle.ts_333333_26sp,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        StrRes.pwdExplanation,
                        style: PageStyle.ts_1D6BED_16sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),
                Obx(() => PwdInputBox(
                      autofocus: true,
                      controller: logic.pwdCtrl,
                      labelStyle: PageStyle.ts_000000_14sp,
                      hintStyle: PageStyle.ts_000000_opacity40p_18sp,
                      textStyle: PageStyle.ts_000000_18sp,
                      showClearBtn: logic.showPwdClearBtn.value,
                      obscureText: logic.obscureText.value,
                      onClickEyesBtn: () => logic.toggleEye(),
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(
                      //     RegExp(r'[\w\W]{6,20}'),
                      //   )
                      // ],
                      eyesBtnColor: Color(0xFF000000).withOpacity(0.4),
                      clearBtnColor: Color(0xFF000000).withOpacity(0.4),
                    )),
                SizedBox(height: 14.h),
                Text(
                  StrRes.pwdRule,
                  style: PageStyle.ts_1D6BED_12sp,
                ),
                SizedBox(height: 155.h),
                Button(
                  textStyle: PageStyle.ts_FFFFFF_18sp,
                  text: StrRes.nextStep,
                  background: PageStyle.c_1D6BED,
                  onTap: () => logic.nextStep(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
