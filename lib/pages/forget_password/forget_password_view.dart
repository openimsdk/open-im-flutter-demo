import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/pages/login/login_logic.dart';
import 'package:openim/widgets/register_page_bg.dart';
import 'package:openim_common/openim_common.dart';

import 'forget_password_logic.dart';

class ForgetPasswordPage extends StatelessWidget {
  final logic = Get.find<ForgetPasswordLogic>();

  ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StrRes.forgetPassword.toText..style = Styles.ts_0089FF_22sp_semibold,
                29.verticalSpace,
                InputBox.account(
                  label: logic.loginController.operateType.name,
                  hintText: logic.loginController.operateType.hintText,
                  code: logic.areaCode.value,
                  onAreaCode: logic.loginController.operateType == LoginType.phone ? logic.openCountryCodePicker : null,
                  controller: logic.phoneCtrl,
                ),
                16.verticalSpace,
                InputBox.verificationCode(
                  label: StrRes.verificationCode,
                  hintText: StrRes.plsEnterVerificationCode,
                  controller: logic.verificationCodeCtrl,
                  onSendVerificationCode: logic.getVerificationCode,
                ),
                130.verticalSpace,
                Button(
                  text: StrRes.nextStep,
                  enabled: logic.enabled.value,
                  onTap: logic.nextStep,
                ),
              ],
            )),
      );
}
