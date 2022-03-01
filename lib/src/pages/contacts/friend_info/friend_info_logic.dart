import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/pages/contacts/friend_info/personal_info/personal_info.dart';
import 'package:openim_demo/src/pages/conversation/conversation_logic.dart';
import 'package:openim_demo/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/custom_dialog.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class FriendInfoLogic extends GetxController {
  late Rx<UserInfo> info;
  var imLoic = Get.find<IMController>();
  var conversationLogic = Get.find<ConversationLogic>();

  // var isExistChatPage = false;

  void toggleBlacklist() {
    if (info.value.isBlacklist == true) {
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
      var result = await OpenIM.iMManager.friendshipManager.addBlacklist(
        uid: info.value.userID!,
      );
      info.update((val) {
        val?.isBlacklist = true;
      });
      print('result:$result');
    }
  }

  /// 从黑名单移除
  void removeBlacklist() async {
    var result = await OpenIM.iMManager.friendshipManager.removeBlacklist(
      uid: info.value.userID!,
    );
    info.update((val) {
      val?.isBlacklist = false;
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
      var result = await OpenIM.iMManager.friendshipManager.deleteFriend(
        uid: info.value.userID!,
      );
      info.update((val) {
        val?.isFriendship = false;
      });
      print('result:$result');
    }
  }

  /// 检查是否是好友
  void checkFriendship() async {
    // var list = await OpenIM.iMManager.friendshipManager
    //     .checkFriend(uidList: [info.value.userID!]);
    // if (list.isNotEmpty) {
    //   info.update((val) {
    //     val?.flag = list.first.flag;
    //   });
    // }
  }

  void toChat() {
    /*if (info.value.isFriendship) {
      print('${info.value.uid}');*/
    // AppNavigator.startChat(
    //   uid: info.value.uid,
    //   name: info.value.getShowName(),
    //   icon: info.value.icon,
    // );
    conversationLogic.startChat(
      uid: info.value.userID,
      name: info.value.getShowName(),
      icon: info.value.faceURL,
      type: 1,
    );
    // }
  }

  void toCall() {}

  void addFriend() {
    if (info.value.userID == OpenIM.iMManager.uid) {
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
        print('--------remarkName:$remarkName---');
        val?.remark = remarkName;
      });
    }
  }

  void getFriendInfo() async {
    var list = await OpenIM.iMManager.userManager.getUsersInfo(
      uidList: [info.value.userID!],
    );
    // var list = await OpenIM.iMManager.friendshipManager.getFriendsInfo(
    //   uidList: [info.value.userID!],
    // );
    if (list.isNotEmpty) {
      var user = list.first;
      info.update((val) {
        val?.nickname = user.nickname;
        val?.faceURL = user.faceURL;
        val?.remark = user.remark;
        val?.gender = user.gender;
        val?.phoneNumber = user.phoneNumber;
        val?.birth = user.birth;
        val?.email = user.email;
        val?.isBlacklist = user.isBlacklist;
        val?.isFriendship = user.isFriendship;
      });
    }
  }

  void recommendFriend() async {
    var result = await AppNavigator.startSelectContacts(
      action: SelAction.RECOMMEND,
      excludeUidList: [info.value.userID!],
    );
    var uid = result['uId'];
    // var name = result['uName'];
    // var icon = result['uIcon'];
    // AppNavigator.startChat();
    var message = await OpenIM.iMManager.messageManager.createCardMessage(
      data: {
        "userID": info.value.userID,
        'nickname': info.value.getShowName(),
        'faceURL': info.value.faceURL
      },
    );
    OpenIM.iMManager.messageManager.sendMessage(
      message: message,
      userID: uid,
      offlinePushInfo: OfflinePushInfo(
        title: '你收到了一条新消息',
        desc: '',
        iOSBadgeCount: true,
        iOSPushSound: '+1',
      ),
    );
  }

  @override
  void onInit() {
    info = Rx(Get.arguments);
    print(' user:   ${json.encode(info.value)}');
    imLoic.friendAddSubject.listen((user) {
      print('add user:   ${json.encode(user)}');
      if (user.userID == info.value.userID) {
        info.update((val) {
          val?.isFriendship = true;
        });
      }
    });
    imLoic.friendInfoChangedSubject.listen((user) {
      print('update user info:   ${json.encode(user)}');
      if (user.userID == info.value.userID) {
        info.update((val) {
          val?.nickname = user.nickname;
          val?.gender = user.gender;
          val?.phoneNumber = user.phoneNumber;
          val?.birth = user.birth;
          val?.email = user.email;
          val?.remark = user.remark;
        });
      }
    });
    getFriendInfo();
    checkFriendship();
    super.onInit();
  }

  void viewPersonalInfo() {
    Get.to(() => PersonalInfoPage());
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
