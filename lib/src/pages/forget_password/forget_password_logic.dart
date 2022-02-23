import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/strings.dart';
import '../../routes/app_navigator.dart';
import '../../utils/im_util.dart';
import '../../widgets/im_widget.dart';

class ForgetPasswordLogic extends GetxController {
  var controller = TextEditingController();
  var showClearBtn = false.obs;
  var isPhoneRegister = true;
  var areaCode = "+86".obs;

  void nextStep() {
    if (isPhoneRegister && !IMUtil.isMobile(controller.text)) {
      IMWidget.showToast(StrRes.plsInputRightPhone);
      return;
    }
    if (!isPhoneRegister && !GetUtils.isEmail(controller.text)) {
      IMWidget.showToast(StrRes.plsInputRightEmail);
      return;
    }
    AppNavigator.startRegisterVerifyPhoneOrEmail(
      areaCode: areaCode.value,
      phoneNumber: isPhoneRegister ? controller.text : null,
      email: !isPhoneRegister ? controller.text : null,
    );
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
