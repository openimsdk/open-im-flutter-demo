import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/pages/conversation/conversation_logic.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';

class SearchAddGroupLogic extends GetxController {
  late Rx<GroupInfo> info;
  var isJoined = false.obs;
  var members = <GroupMembersInfo>[].obs;
  final conversationLogic = Get.find<ConversationLogic>();
  final imLogic = Get.find<IMController>();

  @override
  void onInit() {
    info = Rx(Get.arguments);
    imLogic.groupApplicationChangedSubject.listen((value) {
      _checkGroup();
    });
    _getGroupInfo();
    _checkGroup();
    _getMembers();
    super.onInit();
  }

  _getGroupInfo() async {
    var list = await OpenIM.iMManager.groupManager
        .getGroupsInfo(gidList: [info.value.groupID]);
    if (list.isNotEmpty) {
      var nInfo = list.first;
      info.update((val) {
        val?.groupName = nInfo.groupName;
        val?.faceURL = nInfo.faceURL;
        val?.memberCount = nInfo.memberCount;
      });
    }
  }

  _checkGroup() async {
    isJoined.value = await OpenIM.iMManager.groupManager
        .isJoinedGroup(gid: info.value.groupID);
  }

  _getMembers() async {
    var list = await OpenIM.iMManager.groupManager.getGroupMemberList(
      groupId: info.value.groupID,
    );
    members.assignAll(list);
  }

  enterGroup() async {
    if (isJoined.value) {
      conversationLogic.startChat(
        gid: info.value.groupID,
        name: info.value.groupName,
        icon: info.value.faceURL,
        type: 1,
      );
    } else {
      // OpenIM.iMManager.groupManager.joinGroup(gid: info.groupID,);
      AppNavigator.applyEnterGroup(info.value);
    }
  }
}
