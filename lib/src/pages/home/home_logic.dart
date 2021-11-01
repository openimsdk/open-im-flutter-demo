import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';

class HomeLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  var index = 0.obs;
  var unreadMsgCount = 0.obs;
  var unhandledApplicationCount = 0.obs;

  void switchTab(int i) {
    index.value = i;
  }

  /// 获取消息未读数
  void getUnreadMsgCount() {
    OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount().then((count) {
      unreadMsgCount.value = int.tryParse(count) ?? 0;
    });
  }

  /// 获取申请未处理数
  void getUnhandledApplicationCount() {
    var i = 0;
    OpenIM.iMManager.friendshipManager.getFriendApplicationList().then((list) {
      for (var info in list) {
        if (info.flag == 0) i++;
      }
      unhandledApplicationCount.value = i;
    });
  }

  @override
  void onInit() {
    imLogic.unreadMsgCountEventSubject.listen((value) {
      unreadMsgCount.value = value;
    });
    imLogic.friendApplicationChangedSubject.listen((value) {
      getUnhandledApplicationCount();
    });
    super.onInit();
  }

  @override
  void onReady() {
    getUnreadMsgCount();
    getUnhandledApplicationCount();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
