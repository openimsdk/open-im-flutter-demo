import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../global_search/global_search_logic.dart';
import '../select_contacts_logic.dart';

class SelectContactsFromSearchLogic extends CommonSearchLogic {
  final selectContactsLogic = Get.find<SelectContactsLogic>();
  final resultList = <dynamic>{}.obs;

  bool get isSearchNotResult =>
      searchCtrl.text.trim().isNotEmpty && resultList.isEmpty;

  @override
  void clearList() {
    resultList.clear();
  }

  void search() async {
    final result = await LoadingView.singleton.wrap(
        asyncFunction: () => Future.wait([
              searchFriend(),
              // if (!selectContactsLogic.hiddenOrganization) searchDeptMember(),
              if (!selectContactsLogic.hiddenGroup) searchGroup(),
            ]));
    final friendList = result[0] as List<DeptMemberInfo>;
    final deptMemberList = result[1] as List<DeptMemberInfo>;
    resultList
      ..assignAll(deptMemberList)
      ..addAll(friendList);
    if (result.length == 3) {
      final groupList = result[2] as List<GroupInfo>;
      resultList.addAll(groupList);
    }
  }
}
