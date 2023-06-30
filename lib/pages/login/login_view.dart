import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TouchCloseSoftKeyboard(
        isGradientBg: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              88.verticalSpace,
              ImageRes.loginLogo.toImage
                ..width = 64.w
                ..height = 64.h
                ..onDoubleTap = logic.configService,
              StrRes.welcome.toText..style = Styles.ts_0089FF_17sp_semibold,
              51.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Obx(() => Column(
                      children: [
                        InputBox.phone(
                          label: StrRes.phoneNumber,
                          hintText: StrRes.plsEnterPhoneNumber,
                          code: logic.areaCode.value,
                          onAreaCode: logic.openCountryCodePicker,
                          controller: logic.phoneCtrl,
                        ),
                        16.verticalSpace,
                        InputBox.password(
                          label: StrRes.password,
                          hintText: StrRes.plsEnterPassword,
                          controller: logic.pwdCtrl,
                        ),
                        46.verticalSpace,
                        Button(
                          text: StrRes.login,
                          enabled: logic.enabled.value,
                          onTap: logic.login,
                        ),
                        194.verticalSpace,
                        RichText(
                          text: TextSpan(
                            text: StrRes.noAccountYet,
                            style: Styles.ts_8E9AB0_12sp,
                            children: [
                              TextSpan(
                                text: StrRes.registerNow,
                                style: Styles.ts_0089FF_12sp,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = logic.registerNow,
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
