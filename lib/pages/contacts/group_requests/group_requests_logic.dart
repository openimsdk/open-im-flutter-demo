import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';
import '../../home/home_logic.dart';

class GroupRequestsLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final homeLogic = Get.find<HomeLogic>();
  final list = <GroupApplicationInfo>[].obs;
  final groupList = <String, GroupInfo>{}.obs;
  final memberList = <GroupMembersInfo>[].obs;
  final userInfoList = <UserInfo>[].obs;

  @override
  void onReady() {
    getApplicationList();
    getJoinedGroup();
    super.onReady();
  }

  @override
  void onInit() {
    imLogic.groupApplicationChangedSubject.listen((info) {
      getApplicationList();
    });
    super.onInit();
  }

  @override
  void onClose() {
    homeLogic.getUnhandledGroupApplicationCount();
    super.onClose();
  }

  bool isInvite(GroupApplicationInfo info) {
    if (info.joinSource == 2) {
      return info.inviterUserID != null && info.inviterUserID!.isNotEmpty;
    }
    return false;
  }

  getApplicationList() async {
    final list = await LoadingView.singleton.wrap(asyncFunction: () async {
      final list = await Future.wait([
        OpenIM.iMManager.groupManager.getGroupApplicationListAsRecipient(),
        OpenIM.iMManager.groupManager.getGroupApplicationListAsApplicant(),
      ]);

      final allList = <GroupApplicationInfo>[];
      allList
        ..addAll(list[0])
        ..addAll(list[1]);

      allList.sort((a, b) {
        if (a.reqTime! > b.reqTime!) {
          return -1;
        } else if (a.reqTime! < b.reqTime!) {
          return 1;
        }
        return 0;
      });

      var map = <String, List<String>>{};
      var inviterList = <String>[];

      var haveReadList = DataSp.getHaveReadUnHandleGroupApplication();
      haveReadList ??= <String>[];
      for (var a in list[0]) {
        var id = IMUtils.buildGroupApplicationID(a);
        if (!haveReadList.contains(id)) {
          haveReadList.add(id);
        }
      }
      DataSp.putHaveReadUnHandleGroupApplication(haveReadList);

      var groupIDList = <String>[];

      for (var a in allList) {
        if (isInvite(a)) {
          if (!map.containsKey(a.groupID)) {
            map[a.groupID!] = [a.inviterUserID!];
          } else {
            if (!map[a.groupID!]!.contains(a.inviterUserID!)) {
              map[a.groupID!]!.add(a.inviterUserID!);
            }
          }
          if (!inviterList.contains(a.inviterUserID!)) {
            inviterList.add(a.inviterUserID!);
          }
        }
      }

      if (map.isNotEmpty) {
        await Future.wait(map.entries.map((e) => OpenIM.iMManager.groupManager
            .getGroupMembersInfo(groupID: e.key, userIDList: e.value)
            .then((list) => memberList.assignAll(list))));
      }

      if (inviterList.isNotEmpty) {
        await OpenIM.iMManager.userManager
            .getUsersInfo(userIDList: inviterList)
            .then((list) => userInfoList.assignAll(list.map((e) => e.simpleUserInfo).toList()));
      }

      return allList;
    });

    this.list.assignAll(list);
  }

  void getJoinedGroup() {
    OpenIM.iMManager.groupManager.getJoinedGroupList().then((list) {
      var map = <String, GroupInfo>{};
      for (var e in list) {
        map[e.groupID] = e;
      }
      groupList.addAll(map);
    });
  }

  String getGroupName(GroupApplicationInfo info) => info.groupName ?? groupList[info.groupID]?.groupName ?? '';

  String getInviterNickname(GroupApplicationInfo info) =>
      (getMemberInfo(info.inviterUserID!)?.nickname) ?? (getUserInfo(info.inviterUserID!)?.nickname) ?? '-';

  GroupMembersInfo? getMemberInfo(inviterUserID) => memberList.firstWhereOrNull((e) => e.userID == inviterUserID);

  UserInfo? getUserInfo(inviterUserID) => userInfoList.firstWhereOrNull((e) => e.userID == inviterUserID);

  void handle(GroupApplicationInfo info) async {
    var result = await AppNavigator.startProcessGroupRequests(applicationInfo: info);
    if (result is int) {
      info.handleResult = result;
      list.refresh();
    }
  }
}
