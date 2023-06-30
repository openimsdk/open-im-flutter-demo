import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class GlobalSearchLogic extends CommonSearchLogic {
  @override
  void clearList() {
    // TODO: implement clearList
  }
}

abstract class CommonSearchLogic extends GetxController {
  final searchCtrl = TextEditingController();
  final focusNode = FocusNode();

  void clearList();

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

  _clearInput() {
    if (searchKey.isEmpty) {
      clearList();
    }
  }

  String get searchKey => searchCtrl.text.trim();

  Future<List<DeptMemberInfo>> searchFriend() =>
      OpenIM.iMManager.friendshipManager.searchFriends(
        keywordList: [searchKey],
        isSearchRemark: true,
        isSearchNickname: true,
      ).then((list) =>
          list.map((e) => DeptMemberInfo.fromJson(e.toJson())).toList());

  // Future<List<DeptMemberInfo>> searchDeptMember() =>
  //     OApis.searchDeptMember(keyword: searchKey)
  //         .then((value) => value.departmentMemberList ?? []);

  Future<List<GroupInfo>> searchGroup() =>
      OpenIM.iMManager.groupManager.searchGroups(
        keywordList: [searchCtrl.text.trim()],
        isSearchGroupName: true,
      );

  Future<SearchResult> searchTextMessage({
    int pageIndex = 1,
    int count = 20,
  }) =>
      OpenIM.iMManager.messageManager.searchLocalMessages(
        keywordList: [searchKey],
        messageTypeList: [MessageType.text, MessageType.at_text],
        pageIndex: pageIndex,
        count: count,
      );

  Future<SearchResult> searchFileMessage({
    int pageIndex = 1,
    int count = 20,
  }) =>
      OpenIM.iMManager.messageManager.searchLocalMessages(
        keywordList: [searchKey],
        messageTypeList: [MessageType.file],
        pageIndex: pageIndex,
        count: count,
      );

  String? parseID(e) {
    if (e is ConversationInfo) {
      return e.isSingleChat ? e.userID : e.groupID;
    } else if (e is GroupInfo) {
      return e.groupID;
    } else if (e is UserInfo) {
      return e.userID;
    } else if (e is DeptMemberInfo) {
      return e.userID;
    } else {
      return null;
    }
  }

  String? parseNickname(e) {
    if (e is ConversationInfo) {
      return e.showName;
    } else if (e is GroupInfo) {
      return e.groupName;
    } else if (e is UserInfo) {
      return e.nickname;
    } else if (e is DeptMemberInfo) {
      return e.nickname;
    } else {
      return null;
    }
  }

  String? parseFaceURL(e) {
    if (e is ConversationInfo) {
      return e.faceURL;
    } else if (e is GroupInfo) {
      return e.faceURL;
    } else if (e is UserInfo) {
      return e.faceURL;
    } else if (e is DeptMemberInfo) {
      return e.faceURL;
    } else {
      return null;
    }
  }

  String? parseDeptDetailInfo(info) {
    if (info is DeptMemberInfo) {
      return info.parentDepartmentList?.map((e) => e.name ?? '').join('-');
    }
    return null;
  }

  String? parsePosition(info) {
    if (info is DeptMemberInfo) {
      return info.position;
    }
    return null;
  }
}
