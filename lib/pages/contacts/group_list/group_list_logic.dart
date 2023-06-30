import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';

import '../../conversation/conversation_logic.dart';

class GroupListLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  final index = 0.obs;
  final iCreatedList = <GroupInfo>[].obs;
  final iJoinedList = <GroupInfo>[].obs;
  final allList = <GroupInfo>[];

  @override
  void onReady() {
    _getGroupRelatedToMe();
    super.onReady();
  }

  void switchTab(i) {
    index.value = i;
  }

  void _getGroupRelatedToMe() async {
    final list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
    allList.addAll(list);
    for (var e in list) {
      if (e.ownerUserID == OpenIM.iMManager.userID) {
        iCreatedList.add(e);
      } else {
        iJoinedList.add(e);
      }
    }
  }

  void toGroupChat(GroupInfo info) {
    conversationLogic.toChat(
      offUntilHome: false,
      groupID: info.groupID,
      nickname: info.groupName,
      faceURL: info.faceURL,
      sessionType: info.sessionType,
    );
  }

  void searchGroup() => AppNavigator.startSearchGroup();
}
