import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/core/controller/push_controller.dart';
import 'package:openim_demo/src/pages/server_config/server_config_binding.dart';
import 'package:openim_demo/src/pages/server_config/server_config_view.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

enum LoginType {
  password,
  sms,
}

class LoginLogic extends GetxController {
  var phoneCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var pwdCtrl = TextEditingController();
  var codeCtrl = TextEditingController();
  var phoneFocusNode = FocusNode();
  var emailFocusNode = FocusNode();
  var showAccountClearBtn = false.obs;
  var showPwdClearBtn = false.obs;
  var obscureText = true.obs;
  var agreedProtocol = true.obs;
  var imLogic = Get.find<IMController>();
  var pushLogic = Get.find<PushController>();
  var enabledLoginButton = false.obs;
  var index = 0.obs;
  var areaCode = "+86".obs;
  var loginType = LoginType.password.obs;

  login() async {
    if (index.value == 0 &&
        !IMUtil.isPhoneNumber(areaCode.value, phoneCtrl.text)) {
      IMWidget.showToast(StrRes.plsInputRightPhone);
      return;
    }
    if (index.value == 1 && !GetUtils.isEmail(emailCtrl.text)) {
      IMWidget.showToast(StrRes.plsInputRightEmail);
      return;
    }
    LoadingView.singleton.wrap(asyncFunction: () async {
      var suc = await _login();
      if (suc) {
        AppNavigator.startMain();
      }
    });
  }

  Future<bool> _login() async {
    try {
      var data = await Apis.login(
        areaCode: areaCode.value,
        phoneNumber: index.value == 0 ? phoneCtrl.text : null,
        email: index.value == 1 ? emailCtrl.text : null,
        password: isPasswordLogin ? pwdCtrl.text : null,
        code: isPasswordLogin ? null : codeCtrl.text,
      );
      var account = {
        "areaCode": areaCode.value,
        "phoneNumber": phoneCtrl.text,
        "email": emailCtrl.text,
      };
      await DataPersistence.putLoginCertificate(data);
      await DataPersistence.putAccount(account);
      print(
          '---------login---------- uid: ${data.userID}, token: ${data.imToken}');
      await imLogic.login(data.userID, data.imToken);
      print('---------im login success-------');
      pushLogic.login(data.userID);
      print('---------jpush login success----');
      return true;
    } catch (e) {
      print('login e: $e');
    } finally {}
    return false;
  }

  void register() {
    AppNavigator.startRegister(index.value == 0 ? 'phone' : 'email');
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
      showAccountClearBtn.value = phoneCtrl.text.isNotEmpty;
      _changeLoginButtonStatus();
    });
    emailCtrl.addListener(() {
      showAccountClearBtn.value = emailCtrl.text.isNotEmpty;
      _changeLoginButtonStatus();
    });
    pwdCtrl.addListener(() {
      showPwdClearBtn.value = pwdCtrl.text.isNotEmpty;
      _changeLoginButtonStatus();
    });
    codeCtrl.addListener(() {
      _changeLoginButtonStatus();
    });
    super.onReady();
  }

  void _changeLoginButtonStatus() {
    enabledLoginButton.value = (isPasswordLogin && pwdCtrl.text.isNotEmpty ||
            !isPasswordLogin && codeCtrl.text.isNotEmpty) &&
        (phoneCtrl.text.isNotEmpty || emailCtrl.text.isNotEmpty);
  }

  void toServerConfig() {
    Get.to(() => ServerConfigPage(), binding: ServerConfigBinding());
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    emailCtrl.dispose();
    pwdCtrl.dispose();
    codeCtrl.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  void switchTab(index) {
    // FocusScope.of(Get.context!).requestFocus(FocusNode());
    this.index.value = index;
    phoneCtrl.clear();
    emailCtrl.clear();
    pwdCtrl.clear();
    if (index == 0) {
      emailFocusNode.unfocus();
      phoneFocusNode.requestFocus();
    } else {
      phoneFocusNode.unfocus();
      emailFocusNode.requestFocus();
    }
  }

  void openCountryCodePicker() async {
    String? code = await IMWidget.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  void forgetPassword() {
    AppNavigator.startForgetPassword();
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  void initData() {
    var map = DataPersistence.getAccount();
    if (map is Map) {
      String? areaCode = map["areaCode"];
      String? phoneNumber = map["phoneNumber"];
      String? email = map["email"];
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        phoneCtrl.text = phoneNumber;
      }
      if (areaCode != null && areaCode.isNotEmpty) {
        this.areaCode.value = areaCode;
      }
      if (email != null && email.isNotEmpty) {
        emailCtrl.text = email;
      }
    }
  }

  bool get isPasswordLogin => loginType.value == LoginType.password;

  void switchLoginType() {
    loginType.value = isPasswordLogin ? LoginType.sms : LoginType.password;
  }

  Future<bool> getVerificationCode() async {
    try {
      // await LoadingView.singleton.wrap(
      //     asyncFunction: () => Apis.requestVerificationCode(
      //           areaCode: areaCode.value,
      //           phoneNumber: index.value == 0 ? phoneCtrl.text : null,
      //           email: index.value == 1 ? emailCtrl.text : null,
      //           usedFor: 3,
      //         ));
      IMWidget.showToast(StrRes.sendSuccessfully);
      return true;
    } catch (e) {
      IMWidget.showToast(StrRes.sendFailed);
      return false;
    }
  }
}
