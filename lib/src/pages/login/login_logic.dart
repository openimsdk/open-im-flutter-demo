
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/common/apis.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/core/controller/jpush_controller.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/data_persistence.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';

class LoginLogic extends GetxController {
  var phoneCtrl = TextEditingController();
  var pwdCtrl = TextEditingController();
  var showPhoneClearBtn = false.obs;
  var showPwdClearBtn = false.obs;
  var obscureText = true.obs;
  var agreedProtocol = true.obs;
  var imLogic = Get.find<IMController>();
  // var callLogic = Get.find<CallController>();
  var jPushLogic = Get.find<JPushController>();
  var loginInfo = DataPersistence.getLoginCertificate();
  var enabledLoginButton = false.obs;

  login() async {
    if (phoneCtrl.text.isEmpty || pwdCtrl.text.isEmpty) {
      IMWidget.showToast('请输入手机号和密码');
      return;
    }
    if (!IMUtil.isMobile(phoneCtrl.text)) {
      IMWidget.showToast('请输入正确的手机号');
      return;
    }
    // await Future.delayed(Duration(seconds: 4));
    var suc = await _login(phoneNumber: phoneCtrl.text, pwd: pwdCtrl.text);
    if (suc) {
      AppNavigator.startMain();
    }
  }

  Future<bool> _login(
      {required String phoneNumber, required String pwd}) async {
    try {
      var data = await Apis.login(
          areaCode: '86', phoneNumber: phoneNumber, password: pwd);
      await DataPersistence.putLoginCertificate(data);
      print('---------login---------- uid: ${data.uid}, token: ${data.token}');
      await imLogic.login(data.uid, data.token);
      print('---------im login success-------');
      // await callLogic.login(data.uid, data.token);
      print('---------ion login success------');
      await jPushLogic.login(data.uid);
      print('---------jpush login success----');
      return true;
    } catch (e) {
      print('login e: $e');
    } finally {}
    return false;
  }

  void register() {
    AppNavigator.startRegister();
  }

  void toggleEye() {
    obscureText.value = !obscureText.value;
  }

  void toggleProtocol() {
    agreedProtocol.value = !agreedProtocol.value;
  }

  @override
  void onReady() {
    phoneCtrl.addListener(() {
      showPhoneClearBtn.value = phoneCtrl.text.isNotEmpty;
      _changeLoginButtonStatus();
    });
    pwdCtrl.addListener(() {
      showPwdClearBtn.value = pwdCtrl.text.isNotEmpty;
      _changeLoginButtonStatus();
    });

    if (null != loginInfo && loginInfo!.uid.isNotEmpty) {
      phoneCtrl.text = loginInfo!.uid;
    }
    super.onReady();
  }

  void _changeLoginButtonStatus() {
    enabledLoginButton.value =
        phoneCtrl.text.isNotEmpty && pwdCtrl.text.isNotEmpty;
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    pwdCtrl.dispose();
    super.onClose();
  }
}
