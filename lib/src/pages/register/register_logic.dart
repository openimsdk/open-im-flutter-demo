import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';

class RegisterLogic extends GetxController {
  var phoneCtrl = TextEditingController();
  var showPhoneClearBtn = false.obs;
  var agreedProtocol = true.obs;

  void nextStep() {
    if (!IMUtil.isMobile(phoneCtrl.text)) {
      IMWidget.showToast('请输入正确的手机号');
      return;
    }
    AppNavigator.startRegisterVerifyPhone(
      areaCode: '86',
      phoneNumber: phoneCtrl.text,
    );
    // Get.toNamed(AppRoutes.REGISTER_VERIFY_PHONE);
  }

  void toggleProtocol() {
    agreedProtocol.value = !agreedProtocol.value;
  }

  @override
  void onReady() {
    phoneCtrl.addListener(() {
      showPhoneClearBtn.value = phoneCtrl.text.isNotEmpty;
    });
    super.onReady();
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    super.onClose();
  }
}
