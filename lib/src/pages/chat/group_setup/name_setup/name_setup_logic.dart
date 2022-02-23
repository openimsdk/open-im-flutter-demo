import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';

class GroupNameSetupLogic extends GetxController {
  late Rx<GroupInfo> info;
  var nameCtrl = TextEditingController();
  var imLogic = Get.find<IMController>();
  var enabled = false.obs;

  @override
  void onInit() {
    info = Rx(Get.arguments);
    nameCtrl.text = info.value.groupName ?? '';
    enabled.value = nameCtrl.text.isNotEmpty;
    nameCtrl.addListener(() {
      enabled.value = nameCtrl.text.isNotEmpty;
    });
    super.onInit();
  }

  clear() {
    nameCtrl.clear();
  }

  modifyGroupName() async {
    await OpenIM.iMManager.groupManager.setGroupInfo(
      groupID: info.value.groupID,
      groupName: nameCtrl.text,
    );
    // 更新聊天窗口名
    imLogic.groupInfoUpdatedSubject.add(info.value..groupName = nameCtrl.text);
    //
    info.update((val) {
      val?.groupName = nameCtrl.text;
    });
    Get.back();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }
}
