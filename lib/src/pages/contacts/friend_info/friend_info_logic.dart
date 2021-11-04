import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/widgets/custom_dialog.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';

class FriendInfoLogic extends GetxController {
  late Rx<UserInfo> info;
  var imLoic = Get.find<IMController>();

  // var isExistChatPage = false;

  void toggleBlacklist() {
    if (info.value.isBlocked) {
      removeBlacklist();
    } else {
      addBlacklist();
    }
  }

  /// 加入黑名单
  void addBlacklist() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.areYouSureAddBlacklist,
      rightText: StrRes.sure,
    ));
    if (confirm == true) {
      var result = await OpenIM.iMManager.friendshipManager.addToBlackList(
        uid: info.value.uid,
      );
      info.update((val) {
        val?.isInBlackList = 1;
      });
      print('result:$result');
    }
  }

  /// 从黑名单移除
  void removeBlacklist() async {
    var result = await OpenIM.iMManager.friendshipManager.deleteFromBlackList(
      uid: info.value.uid,
    );
    info.update((val) {
      val?.isInBlackList = 0;
    });
    print('result:$result');
  }

  /// 解除好友关系
  void deleteFromFriendList() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.areYouSureDelFriend,
      rightText: StrRes.delete,
    ));
    if (confirm) {
      var result =
          await OpenIM.iMManager.friendshipManager.deleteFromFriendList(
        uid: info.value.uid,
      );
      info.update((val) {
        val?.flag = 0;
      });
      print('result:$result');
    }
  }

  /// 检查是否是好友
  void checkFriendship() async {
    var list =
        await OpenIM.iMManager.friendshipManager.checkFriend([info.value.uid]);
    if (list.isNotEmpty) {
      info.update((val) {
        val?.flag = list.first.flag;
      });
    }
  }

  void toChat() {
    if (info.value.isFriendship) {
      print('${info.value.uid}');
      AppNavigator.startChat(
        uid: info.value.uid,
        name: info.value.getShowName(),
        icon: info.value.icon,
      );
      // Get.offNamed(AppRoutes.CHAT, arguments: {
      //   'uid': info.value.uid,
      //   'name': info.value.getShowName(),
      //   'icon': info.value.icon,
      // });
      // Get.toNamed(AppRoutes.CHAT, arguments: {
      //   'uid': info.value.uid,
      //   'name': info.value.getShowName(),
      //   'icon': info.value.icon,
      // });
    }
  }

  void toCall() {
    if (info.value.isFriendship) {
      IMWidget.openIMCallSheet(
        uid: info.value.uid,
        name: info.value.getShowName(),
        icon: info.value.icon,
      );
    }
  }

  void addFriend() {
    if (info.value.uid == OpenIM.iMManager.uid) {
      IMWidget.showToast(StrRes.notAddSelf);
      return;
    }
    AppNavigator.startSendFriendRequest(info: info.value);
    // Get.toNamed(AppRoutes.SEND_FRIEND_REQUEST, arguments: info.value);
  }

  void toCopyId() {
    AppNavigator.startFriendIDCode(info: info.value);
    // Get.toNamed(AppRoutes.FRIEND_ID_CODE, arguments: info.value);
  }

  void toSetupRemark() async {
    // var remarkName = await Get.toNamed(
    //   AppRoutes.FRIEND_REMARK,
    //   arguments: info.value,
    // );
    var remarkName =
        await AppNavigator.startSetFriendRemarksName(info: info.value);
    if (remarkName != null) {
      info.update((val) {
        val?.comment = remarkName;
      });
    }
  }

  void getFriendInfo() async {
    // var list = await OpenIM.iMManager.getUsersInfo([info.value.uid]);
    var list = await OpenIM.iMManager.friendshipManager.getFriendsInfo(
      uidList: [info.value.uid],
    );
    if (list.isNotEmpty) {
      var user = list.first;
      info.update((val) {
        val?.name = user.name;
        val?.icon = user.icon;
        val?.comment = user.comment;
        val?.gender = user.gender;
        val?.mobile = user.mobile;
        val?.birth = user.birth;
        val?.email = user.email;
        val?.isInBlackList = user.isInBlackList;
        val?.ex = user.ex;
        // val?.flag = user.flag;
      });
    }
  }

  void recommendFriend() async {
    var result = await AppNavigator.startSelectContacts(
      action: SelAction.RECOMMEND,
      excludeUidList: [info.value.uid],
    );
    var uid = result['uId'];
    // var name = result['uName'];
    // var icon = result['uIcon'];
    // AppNavigator.startChat();
    var message = await OpenIM.iMManager.messageManager.createCardMessage(
      data: {
        "uid": info.value.uid,
        'name': info.value.getShowName(),
        'icon': info.value.icon
      },
    );
    OpenIM.iMManager.messageManager.sendMessage(
      message: message,
      userID: uid,
    );
  }

  @override
  void onInit() {
    info = Rx(Get.arguments);
    imLoic.friendAddSubject.listen((user) {
      print('add user:   ${json.encode(user)}');
      if (user.uid == info.value.uid) {
        info.update((val) {
          val?.flag = 1;
        });
      }
    });
    imLoic.friendInfoChangedSubject.listen((user) {
      print('update user info:   ${json.encode(user)}');
      if (user.uid == info.value.uid) {
        info.update((val) {
          val?.name = user.name;
          val?.gender = user.gender;
          val?.mobile = user.mobile;
          val?.birth = user.birth;
          val?.email = user.email;
        });
      }
    });
    getFriendInfo();
    checkFriendship();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
