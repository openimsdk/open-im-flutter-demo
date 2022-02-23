import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/models/group_member_info.dart' as en;
import 'package:openim_demo/src/pages/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import 'package:openim_demo/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/deep_copy.dart';
import 'package:openim_demo/src/utils/im_util.dart';

import '../group_setup_logic.dart';

class GroupMemberManagerLogic extends GetxController {
  var allList = <en.GroupMembersInfo>[].obs;
  var _ownerList = <en.GroupMembersInfo>[];
  var _memberList = <en.GroupMembersInfo>[];
  var _adminList = <en.GroupMembersInfo>[];
  var _groupSetupLogic = Get.find<GroupSetupLogic>();
  late GroupInfo _groupInfo;
  var _uidList = <String>[];
  var onlineStatus = <String, String>{}.obs;
  var popCtrl = CustomPopupMenuController();

  void getGroupMembers() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMemberListMap(
      groupId: _groupInfo.groupID,
    );
    if (list is List) {
      for (var e in list) {
        var member = en.GroupMembersInfo.fromJson(e);
        // 1普通成员, 2群组，3管理员
        if (member.roleLevel == 1) {
          _memberList.add(member);
        } else if (member.roleLevel == 2) {
          _ownerList.add(member..tagIndex = '↑');
        } else {
          _adminList.add(member..tagIndex = '↑');
        }
        _uidList.add(member.userID!);
      }
      // memberList.addAll(IMUtil.convertToAZList(list).cast());
      _sortList();
    }
    _queryOnlineStatus();
  }

  void _sortList() {
    IMUtil.convertToAZList(allList..assignAll(_memberList));
    allList.insertAll(0, _adminList);
    allList.insertAll(0, _ownerList);
  }

  void viewUserInfo(index) {
    var info = allList.elementAt(index);
    AppNavigator.startFriendInfo(
      info: UserInfo(
        userID: info.userID!,
        nickname: info.nickname,
        faceURL: info.faceURL,
      ),
    );
  }

  void addMember() async {
    var result = await AppNavigator.startSelectContacts(
      action: SelAction.ADD_MEMBER,
      defaultCheckedUidList: allList.map((e) => e.userID!).toList(),
    );

    if (null != result) {
      List<ContactsInfo> list = result;
      await OpenIM.iMManager.groupManager.inviteUserToGroup(
        groupId: _groupInfo.groupID,
        uidList: list.map((e) => e.userID!).toList(),
        reason: 'Come on baby',
      );
      list.forEach((e) {
        _memberList.add(en.GroupMembersInfo.fromJson({
          'groupID': _groupInfo.groupID,
          'userID': e.userID,
          'faceURL': e.faceURL,
          'nickname': e.getShowName(),
        }));
        _uidList.insert(0, e.userID!);
      });
      _sortList();
      _queryOnlineStatus();
      _groupSetupLogic.memberListChanged(allList);
    }
  }

  void deleteMember() async {
    var all = DeepCopy.copy(
      allList.value,
      (v) => en.GroupMembersInfo.fromJson(v.cast()),
    );
    // all.removeWhere((e) => e.role == 1);
    all.removeWhere((e) => e.userID == _groupInfo.ownerUserID);
    var result = await AppNavigator.startGroupMemberList(
      gid: _groupInfo.groupID,
      list: all,
      action: OpAction.DELETE,
    );
    List<GroupMembersInfo>? list = result;
    if (null != list) {
      var removeUidList = list.map((e) => e.userID!).toList();
      await OpenIM.iMManager.groupManager.kickGroupMember(
        groupId: _groupInfo.groupID,
        uidList: removeUidList,
        reason: 'Get out baby',
      );
      _memberList.removeWhere((e) => removeUidList.contains(e.userID));
      _adminList.removeWhere((e) => removeUidList.contains(e.userID));
      _uidList.removeWhere((id) => removeUidList.contains(id));
      _sortList();
      _groupSetupLogic.memberListChanged(allList);
      // memberList.removeWhere((e) => list.contains(e.userId!));
      // memberList.refresh();
    }
  }

  // int length() {
  //   var buttons = isMyGroup() ? 2 : 1;
  //   return memberList.length + buttons;
  // }

  bool isMyGroup() {
    return _groupInfo.ownerUserID == OpenIM.iMManager.uid;
  }

  void search() async {
    var info = await AppNavigator.startSearchMember(list: allList.value);
    if (info != null) {
      AppNavigator.startFriendInfo(
        info: UserInfo(
          userID: info.userID!,
          nickname: info.nickname,
          faceURL: info.faceURL,
        ),
      );
    }
  }

  @override
  void onInit() {
    _groupInfo = Get.arguments;
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

  void _queryOnlineStatus() {
    Apis.queryOnlineStatus(
      uidList: _uidList,
      onlineStatusDescCallback: (map) => onlineStatus.addAll(map),
    );
  }
}
