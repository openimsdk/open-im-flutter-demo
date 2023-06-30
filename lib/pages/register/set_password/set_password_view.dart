import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../widgets/register_page_bg.dart';
import 'set_password_logic.dart';

class SetPasswordPage extends StatelessWidget {
  final logic = Get.find<SetPasswordLogic>();

  SetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StrRes.setInfo.toText..style = Styles.ts_0089FF_22sp_semibold,
            29.verticalSpace,
            InputBox(
              label: StrRes.nickname,
              hintText: StrRes.plsEnterYourNickname,
              controller: logic.nicknameCtrl,
            ),
            17.verticalSpace,
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
            Obx(() => Button(
                  text: StrRes.registerNow,
                  enabled: logic.enabled.value,
                  onTap: logic.nextStep,
                )),
          ],
        ),
      );
}
