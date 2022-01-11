import 'dart:async';

import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneLogic extends GetxController {
  var codeErrorCtrl = StreamController<ErrorAnimationType>();

  // var codeEditCtrl = TextEditingController();
  String? phoneNumber;
  String? areaCode;
  String? email;

  void shake() {
    codeErrorCtrl.add(ErrorAnimationType.shake);
  }

  void onCompleted(value) async {
    try {
      await Apis.checkVerificationCode(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        verificationCode: value,
      );

      AppNavigator.startRegisterSetupPwd(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        verifyCode: value,
      );
    } catch (e) {
      shake();
      IMWidget.showToast('${StrRes.verifyCodeError}:$e');
    }
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    email = Get.arguments['email'];
    super.onInit();
  }

  bool get isPhoneRegister => null != phoneNumber;

  @override
  void onReady() {
    requestVerificationCode();
    super.onReady();
  }

  Future<bool> requestVerificationCode() => Apis.requestVerificationCode(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
      );

  @override
  void onClose() {
    codeErrorCtrl.close();
    // codeEditCtrl.dispose();
    super.onClose();
  }
}
