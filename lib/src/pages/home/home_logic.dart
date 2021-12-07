import 'dart:convert';
import 'dart:developer';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';

class HomeLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  var index = 0.obs;
  var unreadMsgCount = 0.obs;
  var unhandledFriendApplicationCount = 0.obs;
  var unhandledGroupApplicationCount = 0.obs;
  var unhandledCount = 0.obs;

  void switchTab(int i) {
    index.value = i;
  }

  /// 获取消息未读数
  void getUnreadMsgCount() {
    OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount().then((count) {
      unreadMsgCount.value = int.tryParse(count) ?? 0;
    });
  }

  /// 获取好友申请未处理数
  void getUnhandledFriendApplicationCount() {
    var i = 0;
    OpenIM.iMManager.friendshipManager.getFriendApplicationList().then((list) {
      for (var info in list) {
        if (info.flag == 0) i++;
      }
      unhandledFriendApplicationCount.value = i;
      unhandledCount.value = unhandledGroupApplicationCount.value + i;
    });
  }

  /// 获取群申请未处理数
  void getUnhandledGroupApplicationCount() {
    OpenIM.iMManager.groupManager.getGroupApplicationList().then((info) {
      log(json.encode(info));
      var i = info.count ?? 0;
      unhandledGroupApplicationCount.value = i;
      unhandledCount.value = unhandledFriendApplicationCount.value + i;
    });
  }

  @override
  void onInit() {
    imLogic.unreadMsgCountEventSubject.listen((value) {
      unreadMsgCount.value = value;
    });
    imLogic.friendApplicationChangedSubject.listen((value) {
      getUnhandledFriendApplicationCount();
    });
    imLogic.onReceiveJoinApplication = (gid, info, opReason) {
      getUnhandledGroupApplicationCount();
    };
    // imLogic.onMemberEnter = (gid, list) {
    //   getUnhandledGroupApplicationCount();
    // };
    imLogic.memberEnterSubject.listen((value) {
      getUnhandledGroupApplicationCount();
    });
    super.onInit();
  }

  @override
  void onReady() {
    getUnreadMsgCount();
    getUnhandledFriendApplicationCount();
    getUnhandledGroupApplicationCount();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
