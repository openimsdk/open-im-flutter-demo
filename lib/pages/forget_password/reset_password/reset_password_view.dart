import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../widgets/register_page_bg.dart';
import 'reset_password_logic.dart';

class ResetPasswordPage extends StatelessWidget {
  final logic = Get.find<ResetPasswordLogic>();

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StrRes.forgetPassword.toText
                  ..style = Styles.ts_0089FF_22sp_semibold,
                29.verticalSpace,
                InputBox.password(
                  label: StrRes.password,
                  hintText: StrRes.plsEnterPassword,
                  controller: logic.pwdCtrl,
                  formatHintText: StrRes.loginPwdFormat,
                  inputFormatters: [IMUtils.getPasswordFormatter()],
                ),
                17.verticalSpace,
                InputBox.password(
                  label: StrRes.confirmPassword,
                  hintText: StrRes.plsConfirmPasswordAgain,
                  controller: logic.pwdAgainCtrl,
                  inputFormatters: [IMUtils.getPasswordFormatter()],
                ),
                129.verticalSpace,
                Button(
                  text: StrRes.confirmTheChanges,
                  enabled: logic.enabled.value,
                  onTap: logic.confirmTheChanges,
                ),
              ],
            )),
      );
}
