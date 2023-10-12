import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../../core/controller/app_controller.dart';

class RegisterLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final phoneCtrl = TextEditingController();
  final invitationCodeCtrl = TextEditingController();
  final areaCode = "+86".obs;
  final enabled = false.obs;

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
        ? phoneCtrl.text.trim().isNotEmpty &&
            invitationCodeCtrl.text.trim().isNotEmpty
        : phoneCtrl.text.trim().isNotEmpty;
  }

  bool get needInvitationCodeRegister =>
      null != appLogic.clientConfigMap['needInvitationCodeRegister'] &&
      appLogic.clientConfigMap['needInvitationCodeRegister'] != 0;

  String? get invitationCode => IMUtils.emptyStrToNull(invitationCodeCtrl.text);

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  Future<bool> requestVerificationCode() => Apis.requestVerificationCode(
        areaCode: areaCode.value,
        phoneNumber: phoneCtrl.text.trim(),
        usedFor: 1,
        invitationCode: invitationCode,
      );

  void next() async {
    if (!IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return;
    }
    final success = await LoadingView.singleton.wrap(
      asyncFunction: () => requestVerificationCode(),
    );
    if (success) {
      AppNavigator.startVerifyPhone(
        areaCode: areaCode.value,
        phoneNumber: phoneCtrl.text.trim(),
        usedFor: 1,
        invitationCode: invitationCode,
      );
    }
  }
}
