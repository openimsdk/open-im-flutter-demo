import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim/pages/login/login_logic.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../../core/controller/app_controller.dart';

class RegisterLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final phoneCtrl = TextEditingController();
  final invitationCodeCtrl = TextEditingController();
  final areaCode = "+86".obs;
  final enabled = false.obs;
  final loginController = Get.find<LoginLogic>();
  String? get email => loginController.operateType == LoginType.email ? phoneCtrl.text.trim() : null;
  String? get phone =>
      (loginController.operateType == LoginType.phone || loginController.operateType == LoginType.account)
          ? phoneCtrl.text.trim()
          : null;

  @override
  void onClose() {
    phoneCtrl.dispose();
    invitationCodeCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    phoneCtrl.addListener(_onChanged);
    invitationCodeCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    enabled.value = needInvitationCodeRegister
        ? phoneCtrl.text.trim().isNotEmpty && invitationCodeCtrl.text.trim().isNotEmpty
        : phoneCtrl.text.trim().isNotEmpty;
  }

  bool get needInvitationCodeRegister =>
      /*null != appLogic.clientConfigMap['needInvitationCodeRegister'] && appLogic.clientConfigMap['needInvitationCodeRegister'] != '0'*/ false;

  String? get invitationCode => IMUtils.emptyStrToNull(invitationCodeCtrl.text);

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  Future<bool> requestVerificationCode() => Apis.requestVerificationCode(
        areaCode: areaCode.value,
        phoneNumber: phone,
        email: email,
        usedFor: 1,
        invitationCode: invitationCode,
      );

  void next() async {
    if ((loginController.operateType == LoginType.phone || loginController.operateType == LoginType.account) &&
        !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return;
    }

    if (loginController.operateType == LoginType.email && !phoneCtrl.text.isEmail) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return;
    }
    final success = await LoadingView.singleton.wrap(
      asyncFunction: () => requestVerificationCode(),
    );
    if (success) {
      AppNavigator.startVerifyPhone(
        areaCode: areaCode.value,
        phoneNumber: phone,
        email: email,
        usedFor: 1,
        invitationCode: invitationCode,
      );
    }
  }
}
