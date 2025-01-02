import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/pages/contacts/group_profile_panel/group_profile_panel_logic.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

enum SearchType {
  user,
  group,
}

class AddContactsBySearchLogic extends GetxController {
  final refreshCtrl = RefreshController();
  final searchCtrl = TextEditingController();
  final focusNode = FocusNode();
  final userInfoList = <UserFullInfo>[].obs;
  final groupInfoList = <GroupInfo>[].obs;
  late SearchType searchType;
  int pageNo = 0;

  @override
  void onClose() {
    searchCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    searchType = Get.arguments['searchType'] ?? SearchType.user;
    searchCtrl.addListener(() {
      if (searchKey.isEmpty) {
        focusNode.requestFocus();
        userInfoList.clear();
        groupInfoList.clear();
      }
    });
    super.onInit();
  }

  bool get isSearchUser => searchType == SearchType.user;

  String get searchKey => searchCtrl.text.trim();

  bool get isNotFoundUser => userInfoList.isEmpty && searchKey.isNotEmpty;

  bool get isNotFoundGroup => groupInfoList.isEmpty && searchKey.isNotEmpty;

  void search() {
    if (searchKey.isEmpty) return;
    if (isSearchUser) {
      searchUser();
    } else {
      searchGroup();
    }
  }

  void searchUser() async {
    var list = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.searchUserFullInfo(
        content: searchKey,
        pageNumber: pageNo = 1,
        showNumber: 20,
      ),
    );
    userInfoList.assignAll(list ?? []);
    refreshCtrl.refreshCompleted();
    if (null == list || list.isEmpty || list.length < 20) {
      refreshCtrl.loadNoData();
    } else {
      refreshCtrl.loadComplete();
    }
  }

  void loadMoreUser() async {
    var list = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.searchUserFullInfo(
        content: searchKey,
        pageNumber: ++pageNo,
        showNumber: 20,
      ),
    );
    userInfoList.addAll(list ?? []);
    refreshCtrl.refreshCompleted();
    if (null == list || list.isEmpty || list.length < 20) {
      refreshCtrl.loadNoData();
    } else {
      refreshCtrl.loadComplete();
    }
  }

  void searchGroup() async {
    var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
      groupIDList: [searchKey],
    );
    groupInfoList.assignAll(list);
  }

  String getMatchContent(UserFullInfo userInfo) {
    final keyword = searchCtrl.text;

    return sprintf(StrRes.searchNicknameIs, [userInfo.nickname]);
  }

  String? getShowName(dynamic info) {
    if (info is UserFullInfo) {
      return info.nickname;
    } else if (info is GroupInfo) {
      return info.groupName;
    }
    return null;
  }

  void viewInfo(dynamic info) {
    if (info is UserFullInfo) {
      AppNavigator.startUserProfilePane(
        userID: info.userID!,
        nickname: info.nickname,
        faceURL: info.faceURL,
      );
    } else if (info is GroupInfo) {
      AppNavigator.startGroupProfilePanel(
        groupID: info.groupID,
        joinGroupMethod: JoinGroupMethod.search,
      );
    }
  }

  String getShowTitle(info) {
    if (!isSearchUser) {
      return sprintf(StrRes.searchGroupNicknameIs, [getShowName(info)]);
    }

    UserFullInfo userFullInfo = info;
    String? tips, content;
    if (int.tryParse(searchKey) != null) {
      if (searchKey.length == 11) {
        tips = StrRes.phoneNumber;
        content = userFullInfo.phoneNumber ?? searchKey;
      } else {
        tips = StrRes.userID;
        content = userFullInfo.userID;
      }
    } else {
      tips = StrRes.searchNicknameIs;
      content = getShowName(info);
    }
    return "$tips:$content";
  }
}
