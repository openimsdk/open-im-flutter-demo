import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/conversation/conversation_logic.dart';
import 'package:openim_demo/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';

class GroupListLogic extends GetxController {
  var index = 0.obs;
  var iCreatedList = <GroupInfo>[].obs;
  var iJoinedList = <GroupInfo>[].obs;
  var list = <GroupInfo>[];
  var conversationLogic = Get.find<ConversationLogic>();

  void getJoinedGroupList() async {
    list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
    list.forEach((e) {
      if (e.ownerUserID == OpenIM.iMManager.uid) {
        iCreatedList.add(e);
      } else {
        iJoinedList.add(e);
      }
    });
  }

  void toGroupChat(GroupInfo info) {
    // AppNavigator.startChat(
    //   gid: info.groupID,
    //   name: info.groupName,
    //   icon: info.faceUrl,
    // );
    conversationLogic.startChat(
      gid: info.groupID,
      name: info.groupName,
      icon: info.faceURL,
    );
  }

  void createGroup() {
    AppNavigator.startSelectContacts(
      action: SelAction.CRATE_GROUP,
      defaultCheckedUidList: [OpenIM.iMManager.uid],
    );
    // Get.toNamed(
    //   AppRoutes.SELECT_CONTACTS,
    //   arguments: {
    //     'action': SelAction.CRATE_GROUP,
    //     'uidList': [OpenIM.iMManager.uid]
    //   },
    // );
  }

  void searchGroup() {
    AppNavigator.startSearchGroup(list: list);
    // Get.toNamed(AppRoutes.SEARCH_GROUP, arguments: list);
  }

  void switchTab(i) {
    index.value = i;
  }

  @override
  void onReady() {
    getJoinedGroupList();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
