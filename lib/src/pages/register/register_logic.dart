import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

import '../../core/controller/app_controller.dart';

class RegisterLogic extends GetxController {
  var appLogic = Get.find<AppController>();
  var controller = TextEditingController();
  var invitationCodeCtrl = TextEditingController();
  var showClearBtn = false.obs;
  var agreedProtocol = true.obs;
  var isPhoneRegister = true;
  var areaCode = "+86".obs;

  void nextStep() async {
    if (isPhoneRegister &&
        !IMUtil.isPhoneNumber(areaCode.value, controller.text)) {
      IMWidget.showToast(StrRes.plsInputRightPhone);
      return;
    }
    if (!isPhoneRegister && !GetUtils.isEmail(controller.text)) {
      IMWidget.showToast(StrRes.plsInputRightEmail);
      return;
    }

    if (needInvitationCodeRegister && invitationCodeCtrl.text.isEmpty) {
      IMWidget.showToast(StrRes.invitationCodeNotEmpty);
      return;
    }

    final success = await Apis.requestVerificationCode(
      areaCode: areaCode.value,
      phoneNumber: isPhoneRegister ? controller.text : null,
      email: !isPhoneRegister ? controller.text : null,
      usedFor: 1,
      invitationCode: invitationCodeCtrl.text,
    );
    if (success) {
      AppNavigator.startRegisterVerifyPhoneOrEmail(
        areaCode: areaCode.value,
        phoneNumber: isPhoneRegister ? controller.text : null,
        email: !isPhoneRegister ? controller.text : null,
        usedFor: 1,
        invitationCode: invitationCodeCtrl.text,
      );
    }
  }

  void toggleProtocol() {
    agreedProtocol.value = !agreedProtocol.value;
  }

  @override
  void onReady() {
    controller.addListener(() {
      showClearBtn.value = controller.text.isNotEmpty;
    });
    super.onReady();
  }

  @override
  void onClose() {
    controller.dispose();
    invitationCodeCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    isPhoneRegister = Get.arguments['registerWay'] == "phone";
    super.onInit();
  }

  void openCountryCodePicker() async {
    String? code = await IMWidget.showCountryCodePicker();
    if (null != code) {
      areaCode.value = code;
    }
  }

  bool get needInvitationCodeRegister =>
      false /*appLogic.clientConfigMap['needInvitationCodeRegister'] != 0*/;
}
