import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../global_search/global_search_logic.dart';
import '../select_contacts_logic.dart';

class SelectContactsFromSearchLogic extends CommonSearchLogic {
  final selectContactsLogic = Get.find<SelectContactsLogic>();
  final resultList = <dynamic>{}.obs;

  bool get isSearchNotResult => searchCtrl.text.trim().isNotEmpty && resultList.isEmpty;

  @override
  void clearList() {
    resultList.clear();
  }

  void search() async {
    final result = await LoadingView.singleton.wrap(
        asyncFunction: () => Future.wait([
              searchFriend(),
              if (!selectContactsLogic.hiddenGroup) searchGroup(),
            ]));
    final friendList = result[0] as List<FriendInfo>;
    clearList();
    resultList
      ..addAll(friendList);
    if (selectContactsLogic.action == SelAction.addMember) {
      var memberInfoList = await getMemberInfo(friendList.map((e) => e.userID!).toList());
      for (var element in memberInfoList) {
        selectContactsLogic.defaultCheckedIDList.add(element.userID!);
      }
    }
    if (result.length == 3) {
      final groupList = result[2] as List<GroupInfo>;
      resultList.addAll(groupList);
    }
  }

  Future<List<GroupMembersInfo>> getMemberInfo(List<String> uidList) async {
    return await OpenIM.iMManager.groupManager
        .getGroupMembersInfo(groupID: selectContactsLogic.groupID!, userIDList: uidList);
  }
}
