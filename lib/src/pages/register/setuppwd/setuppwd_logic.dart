import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

import '../../../common/apis.dart';
import '../../../widgets/loading_view.dart';

class SetupPwdLogic extends GetxController {
  var pwdCtrl = TextEditingController();
  var showPwdClearBtn = false.obs;
  var obscureText = true.obs;
  var enabled = false.obs;
  String? phoneNumber;
  String? areaCode;
  String? email;
  late int usedFor;
  late String verifyCode;
  String? invitationCode;

  void nextStep() {
    if (pwdCtrl.text.length < 6 || pwdCtrl.text.length > 20) {
      IMWidget.showToast(StrRes.pwdFormatError);
      return;
    }
    if (usedFor == 1) {
      // 设置密码/注册
      AppNavigator.startRegisterSetupSelfInfo(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        verifyCode: verifyCode,
        password: pwdCtrl.text,
        invitationCode: invitationCode,
      );
    } else if (usedFor == 2) {
      //重置密码
      LoadingView.singleton.wrap(asyncFunction: () async {
        await Apis.resetPassword(
          areaCode: areaCode,
          phoneNumber: phoneNumber,
          email: email,
          password: pwdCtrl.text,
          verificationCode: verifyCode,
        ).then((value) {
          AppNavigator.backLogin();
        });
      });
    }
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
    usedFor = Get.arguments['usedFor'];
    invitationCode = Get.arguments['invitationCode'];
    super.onInit();
  }

  @override
  void onReady() {
    pwdCtrl.addListener(() {
      showPwdClearBtn.value = pwdCtrl.text.isNotEmpty;
      enabled.value = pwdCtrl.text.isNotEmpty;
    });
    super.onReady();
  }

  @override
  void onClose() {
    pwdCtrl.dispose();
    super.onClose();
  }
}
