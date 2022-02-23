import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:rxdart/rxdart.dart';

enum SearchType {
  user,
  group,
}

class AddFriendBySearchLogic extends GetxController {
  var searchCtrl = TextEditingController();
  var focusNode = FocusNode();
  var resultSub = PublishSubject<String>();
  var searchType = SearchType.user;
  UserInfo? userInfo;
  GroupInfo? groupInfo;

  /// 根据用户id查询用户信息
  void search() async {
    if (isSearchUser) {
      var list = await OpenIM.iMManager.userManager
          .getUsersInfo(uidList: [searchCtrl.text]);
      if (list.isNotEmpty) {
        userInfo = list.first;
        resultSub.addSafely(userInfo!.userID!);
      } else {
        resultSub.addSafely("");
      }
    } else {
      var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
        gidList: [searchCtrl.text],
      );
      if (list.isNotEmpty) {
        groupInfo = list.first;
        resultSub.addSafely(groupInfo!.groupID);
      } else {
        resultSub.addSafely("");
      }
    }
  }

  void viewInfo() {
    if (isSearchUser) {
      AppNavigator.startFriendInfo(info: userInfo!);
    } else {
      AppNavigator.startSearchAddGroup(info: groupInfo!);
    }
  }

  @override
  void onReady() {
    searchCtrl.addListener(() {
      if (searchCtrl.text.isEmpty) {
        focusNode.requestFocus();
        resultSub.addSafely("");
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    focusNode.dispose();
    resultSub.close();
    super.onClose();
  }

  @override
  void onInit() {
    searchType = Get.arguments['searchType'] ?? SearchType.user;
    super.onInit();
  }

  bool get isSearchUser => searchType == SearchType.user;
}
