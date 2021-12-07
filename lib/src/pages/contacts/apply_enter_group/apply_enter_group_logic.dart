import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';
import 'package:openim_enterprise_chat/src/widgets/loading_view.dart';

class ApplyEnterGroupLogic extends GetxController {
  late GroupInfo info;
  final controller = TextEditingController();

  @override
  void onInit() {
    info = Get.arguments;
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void sendApply() {
    LoadingView.singleton
        .wrap(
            asyncFunction: () => OpenIM.iMManager.groupManager.joinGroup(
                  gid: info.groupID,
                  reason: controller.text,
                ))
        .then((value) => IMWidget.showToast(StrRes.sendSuccessfully))
        .then((value) => Get.back())
        .catchError((e) => IMWidget.showToast(StrRes.sendFailed));
  }
}
