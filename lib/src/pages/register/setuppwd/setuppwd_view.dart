import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/pwd_input_box.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import '../../../widgets/titlebar.dart';
import 'setuppwd_logic.dart';

class SetupPwdPage extends StatelessWidget {
  final logic = Get.find<SetupPwdLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: PageStyle.c_FFFFFF,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EnterpriseTitleBar.backButton(left: 0),
                  SizedBox(height: 49.h),
                  Text(
                    logic.usedFor == 1
                        ? StrRes.plsSetupPwd
                        : StrRes.setupNewPassword,
                    style: PageStyle.ts_171A1D_26sp_medium,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          StrRes.pwdExplanation,
                          style: PageStyle.ts_0089FF_16sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  Obx(() => PwdInputBox(
                        autofocus: true,
                        controller: logic.pwdCtrl,
                        labelStyle: PageStyle.ts_171A1D_14sp,
                        hintStyle: PageStyle.ts_000000_opacity40p_18sp,
                        textStyle: PageStyle.ts_171A1D_17sp,
                        showClearBtn: logic.showPwdClearBtn.value,
                        obscureText: logic.obscureText.value,
                        onClickEyesBtn: () => logic.toggleEye(),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //     RegExp(r'[\w\W]{6,20}'),
                        //   )
                        // ],
                        eyesBtnColor: PageStyle.c_333333,
                        clearBtnColor: PageStyle.c_000000_opacity40p,
                      )),
                  SizedBox(height: 14.h),
                  Text(
                    StrRes.pwdRule,
                    style: PageStyle.ts_0089FF_12sp,
                  ),
                  SizedBox(height: 155.h),
                  Obx(() => Button(
                        textStyle: PageStyle.ts_FFFFFF_18sp,
                        text: logic.usedFor == 1
                            ? StrRes.nextStep
                            : StrRes.confirmModify,
                        enabled: logic.enabled.value,
                        onTap: () => logic.nextStep(),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
