import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/pages/login/login_logic.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../widgets/register_page_bg.dart';
import 'register_logic.dart';

class RegisterPage extends StatelessWidget {
  final logic = Get.find<RegisterLogic>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StrRes.newUserRegister.toText..style = Styles.ts_0089FF_22sp_semibold,
            29.verticalSpace,
            Obx(() => InputBox.account(
                  label: logic.loginController.operateType.name,
                  hintText: logic.loginController.operateType.hintText,
                  code: logic.areaCode.value,
                  onAreaCode: logic.loginController.operateType == LoginType.email ? null : logic.openCountryCodePicker,
                  controller: logic.phoneCtrl,
                )),
            16.verticalSpace,
            if (logic.needInvitationCodeRegister)
              InputBox.invitationCode(
                label: StrRes.invitationCode,
                hintText: sprintf(
                    StrRes.plsEnterInvitationCode, [logic.needInvitationCodeRegister ? '' : '（${StrRes.optional}）']),
                controller: logic.invitationCodeCtrl,
              ),
            130.verticalSpace,
            Obx(() => Button(
                  text: StrRes.nextStep,
                  enabled: logic.enabled.value,
                  onTap: logic.next,
                )),
          ],
        ),
      );
}
