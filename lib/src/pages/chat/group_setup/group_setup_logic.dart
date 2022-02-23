import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/app_controller.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/models/group_member_info.dart' as en;
import 'package:openim_demo/src/pages/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/custom_dialog.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

import '../chat_logic.dart';

class GroupSetupLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var chatLogic = Get.find<ChatLogic>();
  var appLogic = Get.find<AppController>();
  late Rx<GroupInfo> info;
  var memberList = <en.GroupMembersInfo>[].obs;
  var myGroupNickname = "".obs;
  var topContacts = false.obs;
  var noDisturb = false.obs;
  var noDisturbIndex = 0.obs;
  ConversationInfo? conversationInfo;

  getGroupMembers() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMemberListMap(
      groupId: info.value.groupID,
    );

    if (list is List) {
      var l = list.map((e) => en.GroupMembersInfo.fromJson(e));
      memberList.assignAll(l);
      info.update((val) {
        val?.memberCount = l.length;
      });
    }
  }

  getGroupInfo() async {
    var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
      gidList: [info.value.groupID],
    );
    if (list.isEmpty) return;
    var value = list.first;
    info.update((val) {
      val?.groupName = value.groupName;
      val?.faceURL = value.faceURL;
      val?.notification = value.notification;
      val?.introduction = value.introduction;
      val?.memberCount = value.memberCount;
      val?.ownerUserID = value.ownerUserID;
      print('群组id:${value.ownerUserID}');
    });
  }

  getMemberInfo() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupId: info.value.groupID,
      uidList: [OpenIM.iMManager.uid],
    );
    if (list.length > 0) {
      myGroupNickname.value = list.first.nickname ?? '';
    }
  }

  void modifyAvatar() {
    IMWidget.openPhotoSheet(
      onData: (path, url) async {
        if (url != null) {
          await _updateGroupInfo(faceUrl: url);
          info.update((val) {
            val?.faceURL = url;
          });
        }
      },
    );
  }

  void modifyMyGroupNickname() {
    AppNavigator.startModifyMyNicknameInGroup();
    // Get.toNamed(AppRoutes.MY_GROUP_NICKNAME);
  }

  void modifyGroupName() {
    if (info.value.ownerUserID != OpenIM.iMManager.uid) {
      IMWidget.showToast(StrRes.onlyTheOwnerCanModify);
      return;
    }
    AppNavigator.startGroupNameSet(info: info.value);
    // Get.toNamed(AppRoutes.GROUP_NAME_SETUP, arguments: info);
  }

  void editGroupAnnouncement() {
    if (info.value.ownerUserID != OpenIM.iMManager.uid) {
      IMWidget.showToast(StrRes.onlyTheOwnerCanModify);
      return;
    }
    AppNavigator.startEditAnnouncement(info: info.value);
    // Get.toNamed(AppRoutes.GROUP_ANNOUNCEMENT_SETUP, arguments: info);
  }

  void viewGroupQrcode() {
    AppNavigator.startViewGroupQrcode(info: info.value);
    // Get.toNamed(AppRoutes.GROUP_QRCODE, arguments: info.value);
  }

  void viewGroupMembers() async {
    print('群组id:${info.value.ownerUserID}');
    AppNavigator.startGroupMemberManager(info: info.value);
    // await Get.toNamed(
    //   AppRoutes.GROUP_MEMBER_MANAGER,
    //   arguments: info.value,
    // );
    // getGroupMembers();
  }

  void transferGroup() async {
    var list = memberList;
    list.removeWhere((e) => e.userID == info.value.ownerUserID);
    var result = await AppNavigator.startGroupMemberList(
      gid: info.value.groupID,
      list: list,
      action: OpAction.ADMIN_TRANSFER,
    );
    if (null != result) {
      GroupMembersInfo member = result;
      await OpenIM.iMManager.groupManager.transferGroupOwner(
        gid: info.value.groupID,
        uid: member.userID!,
      );

      info.update((val) {
        val?.ownerUserID = member.userID;
      });
    }
  }

  void quitGroup() async {
    if (isMyGroup()) {
      var confirm = await Get.dialog(CustomDialog(
        title: StrRes.quitGroupTransferPermissionHint,
        rightText: StrRes.sure,
      ));
      if (confirm == true) {
        transferGroup();
      }
    } else {
      var confirm = await Get.dialog(CustomDialog(
        title: StrRes.quitGroupHint,
        rightText: StrRes.sure,
      ));
      if (confirm == true) {
        // 退群
        await OpenIM.iMManager.groupManager.quitGroup(
          gid: info.value.groupID,
        );
        // 获取会话id
        String conversationID = await OpenIM.iMManager.conversationManager
            .getConversationIDBySessionType(
          sourceID: info.value.groupID,
          sessionType: 2,
        );
        // 删除群会话
        await OpenIM.iMManager.conversationManager.deleteConversation(
          conversationID: conversationID,
        );
        AppNavigator.startBackMain();
        // Get.until((route) => Get.currentRoute == AppRoutes.HOME);
      }
    }
  }

  void memberListChanged(list) {
    memberList.assignAll(list);
    info.update((val) {
      val?.memberCount = list.length;
    });
  }

  void copyGroupID() {
    AppNavigator.startViewGroupId(info: info.value);
    // Get.toNamed(AppRoutes.GROUP_ID, arguments: info.value);
  }

  bool isMyGroup() {
    return info.value.ownerUserID == OpenIM.iMManager.uid;
  }

  _updateGroupInfo({
    String? groupName,
    String? notification,
    String? introduction,
    String? faceUrl,
  }) {
    return OpenIM.iMManager.groupManager.setGroupInfo(
      groupID: info.value.groupID,
      groupName: groupName,
      notification: notification,
      introduction: introduction,
      faceUrl: faceUrl,
    );
  }

  @override
  void onInit() {
    info = GroupInfo(
      groupID: Get.arguments['gid'],
      groupName: Get.arguments['name'],
      faceURL: Get.arguments['icon'],
      memberCount: 0,
    ).obs;
    imLogic.groupInfoUpdatedSubject.listen((value) {
      if (value.groupID == info.value.groupID) {
        info.update((val) {
          // val?.ownerId = value.ownerId;
          val?.groupName = value.groupName;
          val?.faceURL = value.faceURL;
          val?.notification = value.notification;
          val?.introduction = value.introduction;
          val?.memberCount = value.memberCount;
        });
      }
    });
    imLogic.memberAddedSubject.listen((e) {
      var i = en.GroupMembersInfo.fromJson(e.toJson());
      memberList.add(i);
      info.update((val) {
        val?.memberCount = memberList.length;
      });
    });
    imLogic.memberDeletedSubject.listen((e) {
      memberList.removeWhere((element) => element.userID == e.userID);
      info.update((val) {
        val?.memberCount = memberList.length;
      });
    });
    super.onInit();
  }

  @override
  void onReady() {
    getGroupInfo();
    getConversationInfo();
    getGroupMembers();
    getConversationRecvMessageOpt();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  int length() {
    int buttons = isMyGroup() ? 2 : 1;
    return (memberList.length + buttons) > 7
        ? 7
        : (memberList.length + buttons);
  }

  Widget itemBuilder({
    required int index,
    required Widget Function(GroupMembersInfo info) builder,
    required Widget Function() addButton,
    required Widget Function() delButton,
  }) {
    var length = isMyGroup() ? 5 : 6;
    if (memberList.length > length) {
      if (index < length) {
        var info = memberList.elementAt(index);
        return builder(info);
      } else if (index == length) {
        return addButton();
      } else {
        return delButton();
      }
    } else {
      if (index < memberList.length) {
        var info = memberList.elementAt(index);
        return builder(info);
      } else if (index == memberList.length) {
        return addButton();
      } else {
        return delButton();
      }
    }
  }

  void getConversationInfo() async {
    conversationInfo =
        await OpenIM.iMManager.conversationManager.getOneConversation(
      sourceID: info.value.groupID,
      sessionType: 2,
    );
    topContacts.value = conversationInfo!.isPinned!;
  }

  void toggleTopContacts() async {
    topContacts.value = !topContacts.value;
    if (conversationInfo == null) return;
    await OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: conversationInfo!.conversationID,
      isPinned: topContacts.value,
    );
  }

  void clearChatHistory() async {
    await OpenIM.iMManager.messageManager.clearGroupHistoryMessage(
      gid: info.value.groupID,
    );
    chatLogic.clearAllMessage();
    IMWidget.showToast(StrRes.clearSuccess);
  }

  void toggleNotDisturb() {
    noDisturb.value = !noDisturb.value;
    if (!noDisturb.value) noDisturbIndex.value = 0;
    setConversationRecvMessageOpt(status: noDisturb.value ? 2 : 0);
  }

  void noDisturbSetting() {
    IMWidget.openNoDisturbSettingSheet(
      isGroup: true,
      onTap: (index) {
        setConversationRecvMessageOpt(status: index == 0 ? 2 : 1);
        noDisturbIndex.value = index;
      },
    );
  }

  /// 消息免打扰
  /// 1: Do not receive messages, 2: Do not notify when messages are received; 0: Normal
  void setConversationRecvMessageOpt({int status = 2}) {
    var id = 'group_${info.value.groupID}';
    LoadingView.singleton.wrap(
        asyncFunction: () =>
            OpenIM.iMManager.conversationManager.setConversationRecvMessageOpt(
              conversationIDList: [id],
              status: status,
            ).then((value) => appLogic.notDisturbMap[id] = status != 0));
  }

  /// 消息免打扰
  /// 1: Do not receive messages, 2: Do not notify when messages are received; 0: Normal
  /// [{"conversationId":"single_13922222222","result":0}]
  void getConversationRecvMessageOpt() async {
    var list = await OpenIM.iMManager.conversationManager
        .getConversationRecvMessageOpt(
      conversationIDList: ['group_${info.value.groupID}'],
    );
    if (list.isNotEmpty) {
      var map = list.first;
      var status = map['result'];
      noDisturb.value = status != 0;
      if (noDisturb.value) {
        noDisturbIndex.value = status == 1 ? 1 : 0;
      }
    }
  }
}
