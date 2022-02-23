import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';

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
    OpenIM.iMManager.friendshipManager
        .getRecvFriendApplicationList()
        .then((list) {
      for (var info in list) {
        if (info.handleResult == 0) i++;
      }
      unhandledFriendApplicationCount.value = i;
      unhandledCount.value = unhandledGroupApplicationCount.value + i;
    });
  }

  /// 获取群申请未处理数
  void getUnhandledGroupApplicationCount() {
    OpenIM.iMManager.groupManager.getRecvGroupApplicationList().then((list) {
      var i = list.where((e) => e.handleResult == 0).length;
      print('getUnhandledGroupApplicationCount-----------$i}');
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
    imLogic.groupApplicationChangedSubject.listen((value) {
      getUnhandledGroupApplicationCount();
    });
    // imLogic.memberAddedSubject.listen((value) {
    //   getUnhandledGroupApplicationCount();
    // });
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
