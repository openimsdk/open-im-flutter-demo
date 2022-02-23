import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class SendFriendRequestLogic extends GetxController {
  UserInfo? _userInfo;
  var reasonCtrl = TextEditingController();
  var remarkNameCtrl = TextEditingController();

  void addFriend() {
    if (null != _userInfo) {
      print('addFriend:${_userInfo!.userID}');
      OpenIM.iMManager.friendshipManager
          .addFriend(uid: _userInfo!.userID!, reason: reasonCtrl.text)
          .then((value) => _sendSuc())
          .catchError((e) => _sendFail());
    }
  }

  void _sendSuc() {
    IMWidget.showToast(StrRes.sendSuccessfully);
    Get.back();
  }

  void _sendFail() {
    IMWidget.showToast(StrRes.sendFailed);
  }

  @override
  void onInit() {
    _userInfo = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    reasonCtrl.dispose();
    remarkNameCtrl.dispose();
    super.onClose();
  }
}
