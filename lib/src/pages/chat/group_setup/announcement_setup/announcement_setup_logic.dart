import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/widgets/custom_dialog.dart';

class GroupAnnouncementSetupLogic extends GetxController {
  var enabled = false.obs;
  var inputCtrl = TextEditingController();
  late Rx<GroupInfo> info;

  void setAnnouncement() async {
    var publish = await Get.dialog(CustomDialog(
      title: StrRes.announcementHint,
      rightText: StrRes.publish,
    ));
    if (publish == true) {
      await OpenIM.iMManager.groupManager.setGroupInfo(
        groupID: info.value.groupID,
        notification: inputCtrl.text,
      );
      info.update((val) {
        val?.notification = inputCtrl.text;
      });

      Get.back();
    }
  }

  @override
  void onInit() {
    info = Rx(Get.arguments);
    inputCtrl.text = info.value.notification ?? '';
    inputCtrl.addListener(() {
      enabled.value = inputCtrl.text.trim().isNotEmpty;
    });
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
