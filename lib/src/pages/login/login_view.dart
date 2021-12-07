import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/button.dart';
import 'package:openim_enterprise_chat/src/widgets/debounce_button.dart';
import 'package:openim_enterprise_chat/src/widgets/phone_email_input_box.dart';
import 'package:openim_enterprise_chat/src/widgets/protocol_view.dart';
import 'package:openim_enterprise_chat/src/widgets/pwd_input_box.dart';
import 'package:openim_enterprise_chat/src/widgets/radio_button.dart';
import 'package:openim_enterprise_chat/src/widgets/touch_close_keyboard.dart';

import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage(ImageRes.ic_loginBg),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            height: 1.sh,
            child: Stack(
              children: [
                Positioned(
                  top: 146.h,
                  left: 40.w,
                  child: GestureDetector(
                    onDoubleTap: () => logic.toServerConfig(),
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      StrRes.welcomeUse,
                      style: PageStyle.ts_333333_32sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 229.h,
                  left: 40.w,
                  width: 295.w,
                  child: Obx(() => PhoneEmailInputBox(
                        index: logic.index.value,
                        onChanged: (i) => logic.switchTab(i),
                        onAreaCode: () => logic.openCountryCodePicker(),
                        phoneController: logic.phoneCtrl,
                        emailController: logic.emailCtrl,
                        emailFocusNode: logic.emailFocusNode,
                        phoneFocusNode: logic.phoneFocusNode,
                        labelStyle: PageStyle.ts_333333_14sp,
                        labelSelectedStyle: PageStyle.ts_1D6BED_14sp,
                        hintStyle: PageStyle.ts_333333_opacity40p_18sp,
                        textStyle: PageStyle.ts_333333_18sp,
                        codeStyle: PageStyle.ts_333333_18sp,
                        code: logic.areaCode.value,
                        showClearBtn: logic.showAccountClearBtn.value,
                        arrowColor: PageStyle.c_333333,
                        clearBtnColor: PageStyle.c_333333,
                        indicatorColor: PageStyle.c_1D6BED,
                      )),
                ),
                Positioned(
                  top: 343.h,
                  left: 40.w,
                  width: 295.w,
                  child: Obx(() => PwdInputBox(
                        controller: logic.pwdCtrl,
                        labelStyle: PageStyle.ts_333333_14sp,
                        hintStyle: PageStyle.ts_333333_opacity40p_18sp,
                        textStyle: PageStyle.ts_333333_18sp,
                        showClearBtn: logic.showPwdClearBtn.value,
                        obscureText: logic.obscureText.value,
                        onClickEyesBtn: () => logic.toggleEye(),
                        clearBtnColor: PageStyle.c_333333,
                        eyesBtnColor: PageStyle.c_333333,
                      )),
                ),
                Positioned(
                  top: 419.h,
                  left: 40.w,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      StrRes.forgetPwd,
                      style: PageStyle.ts_333333_12sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 419.h,
                  right: 40.w,
                  child: GestureDetector(
                    onTap: () => logic.register(),
                    behavior: HitTestBehavior.translucent,
                    child: Obx(() => Text(
                          logic.index.value == 0
                              ? StrRes.phoneRegister
                              : StrRes.emailRegister,
                          style: PageStyle.ts_1D6BED_12sp,
                        )),
                  ),
                ),
                Positioned(
                  top: 520.h,
                  left: 40.w,
                  width: 295.w,
                  child: DebounceButton(
                    onTap: () async => await logic.login(),
                    // your tap handler moved here
                    builder: (context, onTap) {
                      return Obx(() => Button(
                            textStyle: logic.enabledLoginButton.value
                                ? PageStyle.ts_FFFFFF_18sp
                                : PageStyle.ts_898989_18sp,
                            text: StrRes.login,
                            background: logic.enabledLoginButton.value
                                ? PageStyle.c_1D6BED
                                : PageStyle.c_D8D8D8,
                            onTap:
                                logic.enabledLoginButton.value ? onTap : null,
                          ));
                    },
                  ),
                  // child: Obx(() => Button(
                  //       textStyle: logic.enabledLoginButton.value
                  //           ? PageStyle.ts_FFFFFF_18sp
                  //           : PageStyle.ts_898989_18sp,
                  //       text: StrRes.login,
                  //       background: logic.enabledLoginButton.value
                  //           ? PageStyle.c_1D6BED
                  //           : PageStyle.c_D8D8D8,
                  //       onTap: logic.enabledLoginButton.value
                  //           ? () => logic.login()
                  //           : null,
                  //     )),
                ),
                Positioned(
                  top: 583.h,
                  width: 375.w,
                  // left: 48.w,
                  // width: 295.w,
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProtocolView(
                            isChecked: logic.agreedProtocol.value,
                            radioStyle: RadioStyle.BLUE,
                            onTap: () => logic.toggleProtocol(),
                            margin: EdgeInsets.only(/*left: 48.w, */ top: 19.h),
                            style1: PageStyle.ts_333333_12sp,
                            style2: PageStyle.ts_1D6BED_12sp,
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
