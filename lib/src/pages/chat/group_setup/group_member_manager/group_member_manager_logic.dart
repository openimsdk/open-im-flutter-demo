import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/models/group_member_info.dart' as en;
import 'package:openim_demo/src/pages/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:openim_demo/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';

import '../group_setup_logic.dart';

class GroupMemberManagerLogic extends GetxController {
  var memberList = <en.GroupMembersInfo>[].obs;
  var groupSetupLogic = Get.find<GroupSetupLogic>();
  late GroupInfo groupInfo;

  void getGroupMembers() async {
    var map = await OpenIM.iMManager.groupManager.getGroupMemberListMap(
      groupId: groupInfo.groupID,
    );
    if (map['data'] is List) {
      memberList.addAll(
        (map['data'] as List).map((e) => en.GroupMembersInfo.fromJson(e)),
      );
    }
  }

  void viewUserInfo(index) {
    var info = memberList.elementAt(index);
    AppNavigator.startFriendInfo(
      info: UserInfo(
        uid: info.userId!,
        name: info.nickName,
        icon: info.faceUrl,
      ),
    );
    // Get.toNamed(
    //   AppRoutes.FRIEND_INFO,
    //   arguments: UserInfo(
    //     uid: info.userId!,
    //     name: info.nickName,
    //     icon: info.faceUrl,
    //   ),
    // );
  }

  void addMember() async {
    // List<ContactsInfo> list = await Get.toNamed(
    //   AppRoutes.SELECT_CONTACTS,
    //   arguments: {
    //     'action': SelAction.ADD_MEMBER,
    //     'uidList': memberList.map((e) => e.userId).toList(),
    //   },
    // );
    var result = await AppNavigator.startSelectContacts(
      action: SelAction.ADD_MEMBER,
      defaultCheckedUidList: memberList.map((e) => e.userId).toList(),
    );

    if (null != result) {
      List<ContactsInfo> list = result;
      await OpenIM.iMManager.groupManager.inviteUserToGroup(
        groupId: groupInfo.groupID,
        uidList: list.map((e) => e.uid).toList(),
        reason: 'Come on baby',
      );

      list.forEach((e) {
        memberList.add(en.GroupMembersInfo.fromJson({
          'groupID': groupInfo.groupID,
          'userId': e.uid,
          'faceUrl': e.icon,
          'nickName': e.getShowName(),
        }));
      });

      groupSetupLogic.memberListChanged(memberList);
    }
  }

  void deleteMember() async {
    var all = memberList.value;
    all.removeWhere((e) => e.userId == groupInfo.ownerId);
    var result = await AppNavigator.startGroupMemberList(
      gid: groupInfo.groupID,
      list: all,
      action: OpAction.DELETE,
    );
    List<GroupMembersInfo>? list = result;
    if (null != list) {
      await OpenIM.iMManager.groupManager.kickGroupMember(
        groupId: groupInfo.groupID,
        uidList: list.map((e) => e.userId!).toList(),
        reason: 'Get out baby',
      );

      list.forEach((e) {
        memberList.remove(e);
      });

      groupSetupLogic.memberListChanged(memberList);
      // memberList.removeWhere((e) => list.contains(e.userId!));
      // memberList.refresh();
    }
  }

  int length() {
    var buttons = isMyGroup() ? 2 : 1;
    return memberList.length + buttons;
  }

  bool isMyGroup() {
    return groupInfo.ownerId == OpenIM.iMManager.uid;
  }

  void search() {
    AppNavigator.startSearchMember(list: memberList.value);
  }

  @override
  void onInit() {
    groupInfo = Get.arguments;
    super.onInit();
  }

  @override
  void onReady() {
    getGroupMembers();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
