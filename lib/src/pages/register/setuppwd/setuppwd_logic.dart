import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class SetupPwdLogic extends GetxController {
  var pwdCtrl = TextEditingController();
  var showPwdClearBtn = false.obs;
  var obscureText = true.obs;
  String? phoneNumber;
  String? areaCode;
  String? email;
  late String verifyCode;

  void nextStep() {
    if (pwdCtrl.text.length < 6 || pwdCtrl.text.length > 20) {
      IMWidget.showToast(StrRes.pwdFormatError);
      return;
    }
    AppNavigator.startRegisterSetupSelfInfo(
      areaCode: areaCode,
      phoneNumber: phoneNumber,
      email: email,
      verifyCode: verifyCode,
      password: pwdCtrl.text,
    );
    // Get.toNamed(AppRoutes.REGISTER_SETUP_SELF_INFO);
  }

  void toggleEye() {
    obscureText.value = !obscureText.value;
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    email = Get.arguments['email'];
    verifyCode = Get.arguments['verifyCode'];
    super.onInit();
  }

  @override
  void onReady() {
    pwdCtrl.addListener(() {
      showPwdClearBtn.value = pwdCtrl.text.isNotEmpty;
    });
    super.onReady();
  }

  @override
  void onClose() {
    pwdCtrl.dispose();
    super.onClose();
  }
}
