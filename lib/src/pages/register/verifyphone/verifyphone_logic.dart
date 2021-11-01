import 'dart:async';

import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/common/apis.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneLogic extends GetxController {
  var codeErrorCtrl = StreamController<ErrorAnimationType>();

  // var codeEditCtrl = TextEditingController();
  var phoneNumber = "";
  var areaCode = "";

  void shake() {
    codeErrorCtrl.add(ErrorAnimationType.shake);
  }

  void onCompleted(value) {
    Apis.checkVerificationCode(
      areaCode: areaCode,
      phoneNumber: phoneNumber,
      verificationCode: value,
    ).then((result) {
      AppNavigator.startRegisterSetupPwd(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        verifyCode: value,
      );
    }).catchError((e) {
      print('--e:$e');
      shake();
      IMWidget.showToast('验证码不正确:$e');
    });
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    super.onInit();
  }

  @override
  void onReady() {
    print('-----------requestVerificationCode---------------');
    requestVerificationCode();
    super.onReady();
  }

  Future<bool> requestVerificationCode() => Apis.requestVerificationCode(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
      );

  @override
  void onClose() {
    codeErrorCtrl.close();
    // codeEditCtrl.dispose();
    super.onClose();
  }
}
