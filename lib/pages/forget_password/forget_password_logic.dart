import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../login/login_logic.dart';

class ForgetPasswordLogic extends GetxController {
  final phoneCtrl = TextEditingController();
  final verificationCodeCtrl = TextEditingController();
  final areaCode = "+86".obs;
  final enabled = false.obs;
  final loginController = Get.find<LoginLogic>();
  String? get email => loginController.operateType == LoginType.email ? phoneCtrl.text.trim() : null;
  String? get phone => loginController.operateType == LoginType.phone ? phoneCtrl.text.trim() : null;
  @override
  void onClose() {
    phoneCtrl.dispose();
    verificationCodeCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    phoneCtrl.addListener(_onChanged);
    verificationCodeCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    enabled.value = phoneCtrl.text.trim().isNotEmpty && verificationCodeCtrl.text.trim().isNotEmpty;
  }

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  Future<bool> getVerificationCode() async {
    if (phone?.isNotEmpty == true && !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return false;
    }

    if (email?.isNotEmpty == true && !phoneCtrl.text.isEmail) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return false;
    }

    final success = await sendVerificationCode();
    return success;
  }

  Future<bool> sendVerificationCode() => LoadingView.singleton.wrap(
      asyncFunction: () => Apis.requestVerificationCode(
            areaCode: areaCode.value,
            phoneNumber: phone,
            email: email,
            usedFor: 2,
          ));

  checkVerificationCode() => LoadingView.singleton.wrap(
      asyncFunction: () => Apis.checkVerificationCode(
            areaCode: areaCode.value,
            phoneNumber: phone,
            email: email,
            verificationCode: verificationCodeCtrl.text,
            usedFor: 2,
          ));

  void nextStep() async {
    await checkVerificationCode();
    AppNavigator.startResetPassword(
      areaCode: areaCode.value,
      phoneNumber: phone,
      email: email,
      verificationCode: verificationCodeCtrl.text,
    );
  }
}
