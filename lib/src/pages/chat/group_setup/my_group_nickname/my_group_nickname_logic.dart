import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MyGroupNicknameLogic extends GetxController {
  var nicknameCtrl = TextEditingController();
  var enabled = false.obs;

  @override
  void onInit() {
    nicknameCtrl.addListener(() {
      enabled.value = nicknameCtrl.text.trim().isNotEmpty;
    });
    super.onInit();
  }

  void clear() {
    nicknameCtrl.clear();
  }

  void modifyMyNickname() {}

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    nicknameCtrl.dispose();
    super.onClose();
  }
}
