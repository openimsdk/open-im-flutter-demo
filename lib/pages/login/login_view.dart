import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

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
                ..height = 64.h,
              StrRes.welcome.toText..style = Styles.ts_0089FF_17sp_semibold,
              51.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(children: [
                  _buildInputView(),
                  46.verticalSpace,
                  Obx(() => Button(
                        text: StrRes.login,
                        enabled: logic.enabled.value,
                        onTap: logic.login,
                      )),
                ]),
              ),
              100.verticalSpace,
              Obx(
                () => Visibility(
                  visible: logic.loginType.value != LoginType.account,
                  child: RichText(
                    text: TextSpan(
                      text: StrRes.noAccountYet,
                      style: Styles.ts_8E9AB0_12sp,
                      children: [
                        TextSpan(
                          text: StrRes.registerNow,
                          style: Styles.ts_0089FF_12sp,
                          recognizer: TapGestureRecognizer()..onTap = _showRegisterBottomSheet,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              32.verticalSpace,
              Obx(() => logic.versionInfo.value.toText..style = Styles.ts_0C1C33_14sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputView() {
    return Container(
      height: 240.h,
      width: 300.w,
      child: Column(
        children: [
          TabBar(
            tabs: LoginType.values.map((e) => Tab(text: e.name)).toList(),
            controller: logic.tabController,
            isScrollable: true,
            indicatorColor: Styles.c_0089FF,
            labelColor: Styles.c_0089FF,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.only(right: 16),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            dividerHeight: 0.1,
            onTap: (index) {
              logic.loginType.value = LoginType.fromRawValue(index);
              logic.operateType = logic.loginType.value;
              FocusScope.of(Get.context!).unfocus();
              logic.phoneCtrl.clear();
              logic.pwdCtrl.clear();
            },
          ),
          Flexible(
            child: Obx(
              () => TabBarView(
                controller: logic.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildInputView1(LoginType.phone),
                  _buildInputView1(LoginType.email),
                  _buildInputView2(LoginType.account),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputView1(LoginType type) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputBox.account(
          label: '',
          hintText: type.hintText,
          code: logic.areaCode.value,
          onAreaCode: type == LoginType.phone ? logic.openCountryCodePicker : null,
          controller: logic.phoneCtrl,
          focusNode: logic.accountFocus,
          keyBoardType: type == LoginType.phone ? TextInputType.phone : TextInputType.text,
        ),
        8.verticalSpace,
        Offstage(
          offstage: !logic.isPasswordLogin.value,
          child: InputBox.password(
            label: '',
            hintText: StrRes.plsEnterPassword,
            controller: logic.pwdCtrl,
            focusNode: logic.pwdFocus,
          ),
        ),
        Offstage(
          offstage: logic.isPasswordLogin.value,
          child: InputBox.verificationCode(
            label: StrRes.verificationCode,
            hintText: StrRes.plsEnterVerificationCode,
            controller: logic.verificationCodeCtrl,
            onSendVerificationCode: logic.getVerificationCode,
          ),
        ),
        10.verticalSpace,
        Row(
          children: [
            StrRes.forgetPassword.toText
              ..style = Styles.ts_8E9AB0_12sp
              ..onTap = logic.forgetPassword,
            const Spacer(),
            (logic.isPasswordLogin.value ? StrRes.verificationCodeLogin : StrRes.passwordLogin).toText
              ..style = Styles.ts_0089FF_12sp
              ..onTap = logic.togglePasswordType,
          ],
        ),
      ],
    );
  }

  Widget _buildInputView2(LoginType type) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputBox.account(
          label: '',
          hintText: type.hintText,
          code: logic.areaCode.value,
          onAreaCode: null,
          controller: logic.phoneCtrl,
          focusNode: logic.accountFocus,
          keyBoardType: TextInputType.text,
        ),
        8.verticalSpace,
        InputBox.password(
          label: '',
          hintText: StrRes.plsEnterPassword,
          controller: logic.pwdCtrl,
          focusNode: logic.pwdFocus,
        ),
      ],
    );
  }

  void _showRegisterBottomSheet() {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.email;
                logic.registerNow();
              },
              child: Text('${StrRes.email} ${StrRes.registerNow}'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.phone;
                logic.registerNow();
              },
              child: Text('${StrRes.phoneNumber} ${StrRes.registerNow}'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(StrRes.cancel),
          ),
        );
      },
    );
  }

  void _showForgetPasswordBottomSheet() {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.email;
                logic.forgetPassword();
              },
              child: Text(sprintf(StrRes.through, [StrRes.email])),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.phone;
                logic.forgetPassword();
              },
              child: Text(sprintf(StrRes.through, [StrRes.phoneNumber])),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(StrRes.cancel),
          ),
        );
      },
    );
  }
}
