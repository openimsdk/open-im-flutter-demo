import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/models/group_member_info.dart' as en;
import 'package:openim_enterprise_chat/src/pages/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/widgets/custom_dialog.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';

class GroupSetupLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  late Rx<GroupInfo> info;
  var memberList = <en.GroupMembersInfo>[].obs;
  var myGroupNickname = "".obs;

  getGroupMembers() async {
    var map = await OpenIM.iMManager.groupManager.getGroupMemberListMap(
      groupId: info.value.groupID,
    );

    if (map['data'] is List) {
      var l = (map['data'] as List).map((e) => en.GroupMembersInfo.fromJson(e));
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
    var value = list.first;
    info.update((val) {
      val?.groupName = value.groupName;
      val?.faceUrl = value.faceUrl;
      val?.notification = value.notification;
      val?.introduction = value.introduction;
      val?.memberCount = value.memberCount;
      val?.ownerId = value.ownerId;
      print('群组id:${value.ownerId}');
    });
  }

  getMemberInfo() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupId: info.value.groupID,
      uidList: [OpenIM.iMManager.uid],
    );
    if (list.length > 0) {
      myGroupNickname.value = list.first.nickName ?? '';
    }
  }

  void modifyAvatar() {
    IMWidget.openPhotoSheet(
      onData: (path, url) async {
        if (url != null) {
          await _updateGroupInfo(faceUrl: url);
          info.update((val) {
            val?.faceUrl = url;
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
    if(info.value.ownerId != OpenIM.iMManager.uid){
      IMWidget.showToast('只有群主能修改');
      return;
    }
    AppNavigator.startGroupNameSet(info: info);
    // Get.toNamed(AppRoutes.GROUP_NAME_SETUP, arguments: info);
  }

  void editGroupAnnouncement() {
    if(info.value.ownerId != OpenIM.iMManager.uid){
      IMWidget.showToast('只有群主能修改');
      return;
    }
    AppNavigator.startEditAnnouncement(info: info);
    // Get.toNamed(AppRoutes.GROUP_ANNOUNCEMENT_SETUP, arguments: info);
  }

  void viewGroupQrcode() {
    AppNavigator.startViewGroupQrcode(info: info.value);
    // Get.toNamed(AppRoutes.GROUP_QRCODE, arguments: info.value);
  }

  void viewGroupMembers() async {
    print('群组id:${info.value.ownerId}');
    AppNavigator.startGroupMemberManager(info: info.value);
    // await Get.toNamed(
    //   AppRoutes.GROUP_MEMBER_MANAGER,
    //   arguments: info.value,
    // );
    // getGroupMembers();
  }

  void transferGroup() async {
    var list = memberList;
    list.removeWhere((e) => e.userId == info.value.ownerId);
    var result = await AppNavigator.startGroupMemberList(
      gid: info.value.groupID,
      list: list,
      action: OpAction.ADMIN_TRANSFER,
    );
    if (null != result) {
      GroupMembersInfo member = result;
      await OpenIM.iMManager.groupManager.transferGroupOwner(
        gid: info.value.groupID,
        uid: member.userId!,
      );

      info.update((val) {
        val?.ownerId = member.userId;
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
        String conversationID =
            await OpenIM.iMManager.conversationManager.getConversationID(
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
    return info.value.ownerId == OpenIM.iMManager.uid;
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
      faceUrl: Get.arguments['icon'],
      memberCount: 0,
    ).obs;
    imLogic.groupInfoUpdatedSubject.listen((value) {
      if (value.groupID == info.value.groupID) {
        info.update((val) {
          val?.ownerId = value.ownerId;
          val?.groupName = value.groupName;
          val?.faceUrl = value.faceUrl;
          val?.notification = value.notification;
          val?.introduction = value.introduction;
          val?.memberCount = value.memberCount;
        });
      }
    });
    // imLogic.onMemberLeave = (gid, info) {
    //   getGroupMembers();
    // };
    // imLogic.onMemberKicked = (gid, info, list) {
    //   getGroupMembers();
    // };
    // imLogic.onMemberInvited = (gid, info, list) {
    //   getGroupMembers();
    // };
    // imLogic.onMemberEnter = (gid, info) {
    //   getGroupMembers();
    // };
    // imLogic.onReceiveJoinApplication = (gid, info, opReason) {
    //   getGroupMembers();
    // };
    super.onInit();
  }

  @override
  void onReady() {
    getGroupInfo();
    getGroupMembers();
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
}
