import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

import '../../../conversation/conversation_logic.dart';
import '../group_list_logic.dart';

class SearchGroupLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  final logic = Get.find<GroupListLogic>();
  final focusNode = FocusNode();
  final searchCtrl = TextEditingController();
  final resultList = <GroupInfo>[].obs;

  @override
  void onInit() {
    searchCtrl.addListener(_clearInput);
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  bool get isSearchNotResult => searchCtrl.text.trim().isNotEmpty && resultList.isEmpty;

  _clearInput() {
    final key = searchCtrl.text.trim();
    if (key.isEmpty) {
      resultList.clear();
    }
  }

  search() async {
    var key = searchCtrl.text.trim();

    final result = await OpenIM.iMManager.groupManager.searchGroups(keywordList: [key], isSearchGroupName: true);
    resultList.clear();
    resultList.addAll(result);
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
}
