import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/common/apis.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/core/controller/jpush_controller.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';

class SetupSelfInfoLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  // var callLogic = Get.find<CallController>();
  var jPushLogic = Get.find<JPushController>();
  var nameCtrl = TextEditingController();
  var showNameClearBtn = false.obs;
  var icon = "".obs;
  late String phoneNumber;
  late String areaCode;
  late String verifyCode;
  late String password;

  // final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    verifyCode = Get.arguments['verifyCode'];
    password = Get.arguments['password'];
    super.onInit();
  }

  var stream = Stream.value(1);

  enterMain() async {
    if (icon.isEmpty) {
      IMWidget.showToast('请上传头像');
      return;
    }
    if (nameCtrl.text.isEmpty) {
      IMWidget.showToast('名字不能为空');
      return;
    }
    await _login();
    // await Future.delayed(Duration(seconds: 5));
  }

  _login() async {
    var data = await Apis.register(
      areaCode: areaCode,
      phoneNumber: phoneNumber,
      password: password,
      verificationCode: verifyCode,
    );
    await adminOperate();
    var uid = data.uid;
    var token = data.token;
    print('---------login---------- uid: $uid, token: $token');
    await imLogic.login(uid, token);
    await syncSelfInfo(uid: uid);
    print('---------im login success-------');
    // await callLogic.login(uid, token);
    // print('---------ion login success------');
    await jPushLogic.login(uid);
    print('---------jpush login success----');
    AppNavigator.startMain();
  }

  /// 管理员操作
  adminOperate() async {
    try {
      // 登录管理员
      var data = await Apis.login2('openIM123456');
      // 以管理员身份为用户导入好友
      // await Apis.importFriends(uid: phoneNumber, token: data.token);
      // 拉用户进群
      await Apis.inviteToGroup(uid: phoneNumber, token: data.token);
    } catch (e) {}
  }

  syncSelfInfo({
    required String uid,
  }) async {
    await OpenIM.iMManager.setSelfInfo(
      uid: uid,
      name: nameCtrl.text,
      icon: icon.value,
      mobile: '+$areaCode $phoneNumber',
    );
  }

  void pickerPic() {
    IMWidget.openPhotoSheet(onData: (path, url) {
      icon.value = url ?? '';
    });
  }

  @override
  void onReady() {
    nameCtrl.addListener(() {
      showNameClearBtn.value = nameCtrl.text.isNotEmpty;
    });

    super.onReady();
  }

  @override
  void onClose() {
    nameCtrl.dispose();

    super.onClose();
  }
}
