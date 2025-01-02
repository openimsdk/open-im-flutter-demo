import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim/pages/login/login_logic.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';
import '../../../routes/app_navigator.dart';

class SetPasswordLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final nicknameCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final pwdAgainCtrl = TextEditingController();
  final enabled = false.obs;
  String? phoneNumber;
  String? email;
  late String areaCode;
  late int usedFor;
  late String verificationCode;
  String? invitationCode;

  @override
  void onClose() {
    nicknameCtrl.dispose();
    pwdCtrl.dispose();
    pwdAgainCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    email = Get.arguments['email'];
    areaCode = Get.arguments['areaCode'];
    usedFor = Get.arguments['usedFor'];
    verificationCode = Get.arguments['verificationCode'];
    invitationCode = Get.arguments['invitationCode'];
    nicknameCtrl.addListener(_onChanged);
    pwdCtrl.addListener(_onChanged);
    pwdAgainCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    enabled.value =
        nicknameCtrl.text.trim().isNotEmpty && pwdCtrl.text.trim().isNotEmpty && pwdAgainCtrl.text.trim().isNotEmpty;
  }

  bool _checkingInput() {
    if (nicknameCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrRes.plsEnterYourNickname);
      return false;
    }
    if (!IMUtils.isValidPassword(pwdCtrl.text)) {
      IMViews.showToast(StrRes.wrongPasswordFormat);
      return false;
    } else if (pwdCtrl.text != pwdAgainCtrl.text) {
      IMViews.showToast(StrRes.twicePwdNoSame);
      return false;
    }
    return true;
  }

  void nextStep() {
    if (_checkingInput()) {
      register();
    }
  }

  void register() async {
    final operateType = Get.find<LoginLogic>().operateType;
    await LoadingView.singleton.wrap(asyncFunction: () async {
      final data = await Apis.register(
        nickname: nicknameCtrl.text.trim(),
        areaCode: areaCode,
        phoneNumber: operateType == LoginType.phone ? phoneNumber : null,
        email: email,
        account: operateType == LoginType.account ? phoneNumber : null,
        password: pwdCtrl.text,
        verificationCode: verificationCode,
        invitationCode: invitationCode,
      );
      if (null == IMUtils.emptyStrToNull(data.imToken) || null == IMUtils.emptyStrToNull(data.chatToken)) {
        AppNavigator.startLogin();
        return;
      }
      final account = {"areaCode": areaCode, "phoneNumber": phoneNumber, 'email': email};
      await DataSp.putLoginCertificate(data);
      await DataSp.putLoginAccount(account);
      DataSp.putLoginType(email != null ? 1 : 0);
      await imLogic.login(data.userID, data.imToken);
      Logger.print('---------im login success-------');
      PushController.login(data.userID);
      Logger.print('---------jpush login success----');
    });
    AppNavigator.startMain();
  }
}
