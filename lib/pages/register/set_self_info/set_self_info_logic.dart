import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';

class SetSelfInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final nicknameCtrl = TextEditingController();
  late String phoneNumber;
  late String areaCode;
  late String password;
  late String verificationCode;
  String? invitationCode;
  final nickname = ''.obs;
  final faceURL = "".obs;
  final gender = 1.obs;

  @override
  void onClose() {
    nicknameCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    areaCode = Get.arguments['areaCode'];
    password = Get.arguments['password'];
    verificationCode = Get.arguments['verificationCode'];
    invitationCode = Get.arguments['invitationCode'];
    nicknameCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    nickname.value = nicknameCtrl.text.trim();
  }

  void openPhotoSheet() {
    IMViews.openPhotoSheet(onData: (path, url) async {
      if (url != null) {
        faceURL.value = url;
      }
    });
  }
}
