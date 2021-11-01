import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:rxdart/rxdart.dart';

class AddFriendBySearchLogic extends GetxController {
  var searchCtrl = TextEditingController();
  var focusNode = FocusNode();
  var resultSub = PublishSubject<List<UserInfo>>();

  /// 根据用户id查询用户信息
  void search() async {
    var list = await OpenIM.iMManager.getUsersInfo([searchCtrl.text]);
    resultSub.addSafely(list);
  }

  void viewUserInfo(UserInfo info) {
    AppNavigator.startFriendInfo(info: info);
    // Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
  }

  @override
  void onReady() {
    searchCtrl.addListener(() {
      if (searchCtrl.text.isEmpty) {
        focusNode.requestFocus();
        resultSub.addSafely([]);
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    focusNode.dispose();
    resultSub.close();
    super.onClose();
  }
}
