import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class FriendRemarkLogic extends GetxController {
  late UserInfo info;
  var inputCtrl = TextEditingController();
  // var focusNode = FocusNode();

  void save() {
    // if (inputCtrl.text.isEmpty) {
    //   IMWidget.showToast(StrRes.remarkNotEmpty);
    //   return;
    // }
    OpenIM.iMManager.friendshipManager
        .setFriendRemark(uid: info.userID!, remark: inputCtrl.text.trim())
        .then(
      (value) {
        IMWidget.showToast(StrRes.saveSuccessfully);
        Get.back(result: inputCtrl.text.trim());
        return value;
      },
    ).catchError((e) => IMWidget.showToast(StrRes.saveFailed));
  }

  @override
  void onInit() {
    info = Get.arguments;
    inputCtrl.text = info.remark ?? '';
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
    // focusNode.dispose();
    super.onClose();
  }
}
