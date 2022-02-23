import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class SetupUserNameLogic extends GetxController {
  var inputCtrl = TextEditingController();

  void setupName() async {
    await OpenIM.iMManager.userManager.setSelfInfo(
      nickname: inputCtrl.text,
    );
    Get.back(result: inputCtrl.text);
  }

  @override
  void onInit() {
    inputCtrl.text = OpenIM.iMManager.uInfo.nickname ?? '';
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }
}
