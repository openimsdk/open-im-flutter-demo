import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/core/controller/jpush_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

class SetupSelfInfoLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var jPushLogic = Get.find<JPushController>();
  var nameCtrl = TextEditingController();
  var showNameClearBtn = false.obs;
  var icon = "".obs;
  String? phoneNumber;
  String? areaCode;
  String? email;
  late String verifyCode;
  late String password;
  var avatarIndex = 0.obs;

  // final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    email = Get.arguments['email'];
    verifyCode = Get.arguments['verifyCode'];
    password = Get.arguments['password'];
    avatarIndex.value = -1;
    // avatarIndex = Random().nextInt(indexAvatarList.length);
    super.onInit();
  }

  var stream = Stream.value(1);

  enterMain() async {
    if (icon.isEmpty && avatarIndex.value == -1) {
      IMWidget.showToast(StrRes.plsUploadAvatar);
      return;
    }
    if (nameCtrl.text.isEmpty) {
      IMWidget.showToast(StrRes.nameNotEmpty);
      return;
    }

    LoadingView.singleton.wrap(asyncFunction: () => _login());
    // await _login();
  }

  _login() async {
    var data = await Apis.register(
      areaCode: areaCode,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      verificationCode: verifyCode,
    );

    var uid = data.uid;
    var token = data.token;
    print('---------login---------- uid: $uid, token: $token');
    await imLogic.login(uid, token);
    await syncSelfInfo(uid);
    await adminOperate(uid);
    print('---------im login success-------');
    jPushLogic.login(uid);
    print('---------jpush login success----');
    AppNavigator.startMain();
  }

  /// 管理员操作
  adminOperate(uid) async {
    try {
      // 登录管理员
      var data = await Apis.login2('openIM123456');
      // 以管理员身份为用户导入好友
      // await Apis.importFriends(uid: phoneNumber, token: data.token);
      // 拉用户进群
      await Apis.inviteToGroup(uid: uid, token: data.token);
    } catch (e) {}
  }

  syncSelfInfo(String uid) async {
    await OpenIM.iMManager.setSelfInfo(
      name: nameCtrl.text,
      icon: icon.isEmpty ? indexAvatarList[avatarIndex.value] : icon.value,
      mobile: phoneNumber,
      email: email,
    );
  }

  void pickerPic() {
    IMWidget.openPhotoSheet(
        onData: (path, url) {
          icon.value = url ?? '';
          if (icon.isNotEmpty) avatarIndex.value = -1;
        },
        isAvatar: true,
        onIndexAvatar: (index) {
          if (null != index) {
            avatarIndex.value = index;
            icon.value = "";
          }
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
