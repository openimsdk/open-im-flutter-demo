import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/pages/conversation/conversation_logic.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';

class SearchAddGroupLogic extends GetxController {
  late Rx<GroupInfo> info;
  var isJoined = false.obs;
  var members = <GroupMembersInfo>[].obs;
  final conversationLogic = Get.find<ConversationLogic>();
  final imLogic = Get.find<IMController>();

  @override
  void onInit() {
    info = Rx(Get.arguments);
    imLogic.onGroupApplicationProcessed = (gid, op, agreeOrReject, opReason) {
      _checkGroup();
    };
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
        val?.faceUrl = nInfo.faceUrl;
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
    if (list.data != null) {
      members.addAll(list.data!);
    }
  }

  enterGroup() async {
    if (isJoined.value) {
      conversationLogic.startChat(
        gid: info.value.groupID,
        name: info.value.groupName,
        icon: info.value.faceUrl,
        type: 1,
      );
    } else {
      // OpenIM.iMManager.groupManager.joinGroup(gid: info.groupID,);
      AppNavigator.applyEnterGroup(info.value);
    }
  }
}
