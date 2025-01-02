import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../../routes/app_navigator.dart';
import '../friend_list_logic.dart';

class SearchFriendLogic extends GetxController {
  final logic = Get.find<FriendListLogic>();
  final focusNode = FocusNode();
  final searchCtrl = TextEditingController();
  final resultList = <ISUserInfo>[].obs;
  late bool isMultiModel;

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
    resultList.clear();
    if (key.isNotEmpty) {
      final result = await OpenIM.iMManager.friendshipManager
          .searchFriends(keywordList: [key], isSearchNickname: true, isSearchRemark: true, isSearchUserID: true);
      final users = result.map((e) => ISUserInfo.fromJson(e.toJson())).toList();
      resultList.addAll(users);
    }
  }

  viewFriendInfo(ISUserInfo info) => AppNavigator.startUserProfilePane(
        userID: info.userID!,
        offAndToNamed: true,
      );
}
