import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/apis.dart';
import '../../res/strings.dart';
import '../../routes/app_navigator.dart';
import '../../utils/im_util.dart';
import '../../widgets/im_widget.dart';

class ForgetPasswordLogic extends GetxController {
  var controller = TextEditingController();
  var showClearBtn = false.obs;
  var isPhoneRegister = true;
  var areaCode = "+86".obs;
  var enabled = false.obs;

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
    await Apis.requestVerificationCode(
      areaCode: areaCode.value,
      phoneNumber: isPhoneRegister ? controller.text : null,
      email: !isPhoneRegister ? controller.text : null,
      usedFor: 2,
    );
    AppNavigator.startRegisterVerifyPhoneOrEmail(
      areaCode: areaCode.value,
      phoneNumber: isPhoneRegister ? controller.text : null,
      email: !isPhoneRegister ? controller.text : null,
      usedFor: 2,
    );
  }

  @override
  void onReady() {
    controller.addListener(() {
      showClearBtn.value = controller.text.isNotEmpty;
      enabled.value = controller.text.isNotEmpty;
    });
    super.onReady();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    isPhoneRegister = Get.arguments['accountType'] == "phone";
    super.onInit();
  }

  void openCountryCodePicker() async {
    String? code = await IMWidget.showCountryCodePicker();
    if (null != code) {
      areaCode.value = code;
    }
  }
}
