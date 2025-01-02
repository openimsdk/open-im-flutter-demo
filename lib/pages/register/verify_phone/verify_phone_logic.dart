import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../routes/app_navigator.dart';

class VerifyPhoneLogic extends GetxController {
  final codeErrorCtrl = StreamController<ErrorAnimationType>();
  final codeEditCtrl = TextEditingController();
  final enabled = false.obs;
  String? phoneNumber;
  String? email;
  late String areaCode;
  late int usedFor;
  String? invitationCode;

  String get account => phoneNumber?.isNotEmpty == true ? (areaCode + phoneNumber!) : email!;
  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    email = Get.arguments['email'];
    areaCode = Get.arguments['areaCode'];
    usedFor = Get.arguments['usedFor'];
    invitationCode = Get.arguments['invitationCode'];
    codeEditCtrl.addListener(_onChanged);
    super.onInit();
  }

  @override
  void onClose() {
    codeErrorCtrl.close();
    super.onClose();
  }

  void _onChanged() {
    enabled.value = codeEditCtrl.text.length == 6;
  }

  void shake() {
    codeErrorCtrl.add(ErrorAnimationType.shake);
  }

  Future<bool> requestVerificationCode() => LoadingView.singleton.wrap(
      asyncFunction: () => Apis.requestVerificationCode(
            areaCode: areaCode,
            phoneNumber: phoneNumber,
            email: email,
            usedFor: usedFor,
            invitationCode: invitationCode,
          ));

  Future checkVerificationCode(String verificationCode) => Apis.checkVerificationCode(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        verificationCode: verificationCode,
        usedFor: usedFor,
        invitationCode: invitationCode,
      );

  void completed(value) async {
    try {
      await LoadingView.singleton.wrap(
        asyncFunction: () => checkVerificationCode(value),
      );
      AppNavigator.startSetPassword(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        verificationCode: value,
        usedFor: usedFor,
        invitationCode: invitationCode,
      );
    } catch (e, s) {
      shake();
    }
  }
}
