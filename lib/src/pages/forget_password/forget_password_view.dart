import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import '../../res/strings.dart';
import '../../res/styles.dart';
import '../../widgets/button.dart';
import '../../widgets/phone_input_box.dart';
import '../../widgets/titlebar.dart';
import 'forget_password_logic.dart';

class ForgetPasswordPage extends StatelessWidget {
  final logic = Get.find<ForgetPasswordLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: PageStyle.c_FFFFFF,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnterpriseTitleBar.backButton(),
                Padding(
                  padding: EdgeInsets.only(left: 32.w, top: 49.h),
                  child: Text(
                    StrRes.forgetPwd,
                    style: PageStyle.ts_333333_26sp,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32.w, top: 44.h, right: 32.w),
                  child: Obx(() => PhoneInputBox(
                        controller: logic.controller,
                        labelStyle: PageStyle.ts_000000_14sp,
                        hintStyle: PageStyle.ts_000000_opacity40p_18sp,
                        textStyle: PageStyle.ts_000000_18sp,
                        codeStyle: PageStyle.ts_000000_18sp,
                        arrowColor: PageStyle.c_000000,
                        clearBtnColor: PageStyle.c_000000_opacity40p,
                        code: logic.areaCode.value,
                        onAreaCode: () => logic.openCountryCodePicker(),
                        showClearBtn: logic.showClearBtn.value,
                        inputWay: logic.isPhoneRegister
                            ? InputWay.phone
                            : InputWay.email,
                      )),
                ),
                Button(
                  textStyle: PageStyle.ts_FFFFFF_18sp,
                  margin: EdgeInsets.only(top: 206.h, left: 32.w, right: 32.w),
                  text: StrRes.getVerificationCode,
                  background: PageStyle.c_1D6BED,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
