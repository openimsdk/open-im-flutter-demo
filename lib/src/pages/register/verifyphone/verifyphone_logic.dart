import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneLogic extends GetxController {
  var codeErrorCtrl = StreamController<ErrorAnimationType>();
  var codeEditCtrl = TextEditingController(text: '');
  String? phoneNumber;
  String? areaCode;
  String? email;
  late int usedFor;
  String? invitationCode;
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
        usedFor: usedFor,
        invitationCode: invitationCode,
      );

      AppNavigator.startSetupPwd(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        verifyCode: value,
        usedFor: usedFor,
        invitationCode: invitationCode,
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
    usedFor = Get.arguments['usedFor'];
    invitationCode = Get.arguments['invitationCode'];
    super.onInit();
  }

  bool get isPhoneRegister => null != phoneNumber;

  @override
  void onReady() {
    super.onReady();
  }

  Future<bool> requestVerificationCode() => Apis.requestVerificationCode(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        usedFor: usedFor,
        invitationCode: invitationCode,
      );

  @override
  void onClose() {
    codeErrorCtrl.close();
    // codeEditCtrl.dispose();
    super.onClose();
  }
}
