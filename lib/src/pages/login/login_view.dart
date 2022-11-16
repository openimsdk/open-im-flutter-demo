import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/code_input_box.dart';
import 'package:openim_demo/src/widgets/debounce_button.dart';
import 'package:openim_demo/src/widgets/pwd_input_box.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import '../../widgets/phone_input_box.dart';
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
                  top: 136.h,
                  left: 40.w,
                  child: GestureDetector(
                    onDoubleTap: () => logic.toServerConfig(),
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      StrRes.welcomeUse,
                      style: PageStyle.ts_171A1D_32sp_semibold,
                    ),
                  ),
                ),
                Positioned(
                  top: 260.h,
                  left: 40.w,
                  width: 295.w,
                  child: Obx(() => PhoneInputBox(
                        controller: logic.phoneCtrl,
                        labelStyle: PageStyle.ts_171A1D_14sp,
                        hintStyle: PageStyle.ts_171A1D0_opacity40p_17sp,
                        textStyle: PageStyle.ts_171A1D_17sp,
                        codeStyle: PageStyle.ts_171A1D_17sp,
                        arrowColor: PageStyle.c_000000,
                        clearBtnColor: PageStyle.c_000000_opacity40p,
                        code: logic.areaCode.value,
                        onAreaCode: () => logic.openCountryCodePicker(),
                        showClearBtn: logic.showAccountClearBtn.value,
                        inputWay: InputWay.phone,
                      )),
                ),
                Positioned(
                  top: 345.h,
                  left: 40.w,
                  width: 295.w,
                  child: Obx(() => logic.isPasswordLogin
                      ? PwdInputBox(
                          controller: logic.pwdCtrl,
                          labelStyle: PageStyle.ts_171A1D_14sp,
                          hintStyle: PageStyle.ts_171A1D0_opacity40p_17sp,
                          textStyle: PageStyle.ts_171A1D_17sp,
                          showClearBtn: logic.showPwdClearBtn.value,
                          obscureText: logic.obscureText.value,
                          onClickEyesBtn: () => logic.toggleEye(),
                          clearBtnColor: PageStyle.c_000000_opacity40p,
                          eyesBtnColor: PageStyle.c_333333,
                        )
                      : CodeInputBox(
                          controller: logic.codeCtrl,
                          labelStyle: PageStyle.ts_171A1D_14sp,
                          hintStyle: PageStyle.ts_171A1D0_opacity40p_17sp,
                          textStyle: PageStyle.ts_171A1D_17sp,
                          onClickCodeBtn: logic.getVerificationCode,
                        )),
                ),
                Positioned(
                  top: 419.h,
                  left: 40.w,
                  child: GestureDetector(
                    onTap: logic.switchLoginType,
                    behavior: HitTestBehavior.translucent,
                    child: Obx(() => Text(
                          logic.isPasswordLogin
                              ? StrRes.useSMSLogin
                              : StrRes.usePwdLogin,
                          style: PageStyle.ts_0089FF_12sp,
                        )),
                  ),
                ),
                /*Positioned(
                  top: 419.h,
                  right: 40.w,
                  child: GestureDetector(
                    onTap: () => logic.register(),
                    behavior: HitTestBehavior.translucent,
                    child: Obx(() => Text(
                          logic.index.value == 0
                              ? StrRes.phoneRegister
                              : StrRes.emailRegister,
                          style: PageStyle.ts_0089FF_12sp,
                        )),
                  ),
                ),*/
                Positioned(
                  top: 520.h,
                  left: 40.w,
                  width: 295.w,
                  child: DebounceButton(
                    onTap: () async => await logic.login(),
                    // your tap handler moved here
                    builder: (context, onTap) {
                      return Obx(() => Button(
                            enabled: logic.enabledLoginButton.value,
                            text: StrRes.login,
                            onTap: onTap,
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
                // Positioned(
                //   top: 583.h,
                //   width: 375.w,
                //   // left: 48.w,
                //   // width: 295.w,
                //   child: Obx(() => ProtocolView(
                //         isChecked: logic.agreedProtocol.value,
                //         radioStyle: RadioStyle.BLUE,
                //         onTap: () => logic.toggleProtocol(),
                //         margin: EdgeInsets.only(top: 19.h),
                //         style1: PageStyle.ts_333333_12sp,
                //         style2: PageStyle.ts_1D6BED_12sp,
                //       )),
                // )

                Positioned(
                  bottom: 60.h,
                  width: 375.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () => logic.forgetPassword(),
                        behavior: HitTestBehavior.translucent,
                        child: Text(
                          StrRes.forgetPwd,
                          style: PageStyle.ts_0089FF_12sp,
                        ),
                      ),
                      Container(
                        width: 1.w,
                        height: 15.h,
                        color: PageStyle.c_A2A3A5,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                      ),
                      GestureDetector(
                        onTap: () => logic.register(),
                        behavior: HitTestBehavior.translucent,
                        child: Obx(() => Text(
                              logic.index.value == 0
                                  ? StrRes.phoneRegister
                                  : StrRes.emailRegister,
                              style: PageStyle.ts_0089FF_12sp,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
