import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';
import 'package:openim_demo/src/widgets/verify_code_send_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../widgets/button.dart';
import 'verifyphone_logic.dart';

class VerifyPhonePage extends StatelessWidget {
  final logic = Get.find<VerifyPhoneLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    logic.isPhoneRegister
                        ? StrRes.verifyCodeSentToPhone
                        : StrRes.verifyCodeSentToEmail,
                    style: PageStyle.ts_171A1D_26sp_medium,
                  ),
                  Text(
                    logic.isPhoneRegister
                        ? '${logic.areaCode} ${logic.phoneNumber}'
                        : logic.email!,
                    style: PageStyle.ts_0089FF_16sp,
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    StrRes.plsInputCode,
                    style: PageStyle.ts_171A1D_14sp,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    controller: logic.codeEditCtrl,
                    autoFocus: true,
                    // pastedTextStyle: TextStyle(
                    //   color: Colors.green.shade600,
                    //   fontWeight: FontWeight.bold,
                    // ),
                    length: 6,
                    obscureText: false,
                    // obscuringCharacter: '*',
                    // obscuringWidget: FlutterLogo(
                    //   size: 24,
                    // ),
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      return null;
                      // if (v!.length < 3) {
                      //   return "I'm from validator";
                      // } else {
                      //   return null;
                      // }
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      activeColor: const Color(0xFF0089FF),
                      selectedColor: const Color(0xFF0089FF),
                      inactiveColor: const Color(0xFF999999),
                      disabledColor: const Color(0xFF999999),
                      activeFillColor: const Color(0xFF999999),
                      selectedFillColor: const Color(0xFF999999),
                      inactiveFillColor: const Color(0xFF999999),
                      // borderRadius: BorderRadius.circular(5),
                      // fieldHeight: 50,
                      // fieldWidth: 40,
                      // activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    // enableActiveFill: true,
                    errorAnimationController: logic.codeErrorCtrl,
                    // controller: logic.codeEditCtrl,
                    keyboardType: TextInputType.number,
                    // boxShadows: [
                    //   BoxShadow(
                    //     offset: Offset(0, 1),
                    //     color: Colors.black12,
                    //     blurRadius: 10,
                    //   )
                    // ],
                    onCompleted: (v) {
                      logic.onCompleted(v);
                    },
                    onSubmitted: (v) {
                      logic.onCompleted(v);
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (v) {
                      // logic.onCompleted(v);
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                  VerifyCodeSendButton(
                    sec: 300,
                    onTapCallback: () async {
                      return logic.requestVerificationCode();
                    },
                  ),
                  Button(
                    onTap: () => logic.onCompleted(logic.codeEditCtrl.text),
                    margin: EdgeInsets.only(top: 59.h),
                    text: StrRes.nextStep,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
