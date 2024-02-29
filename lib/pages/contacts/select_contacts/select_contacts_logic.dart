import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import 'select_contacts_view.dart';

enum SelAction {
  forward,

  carte,

  crateGroup,

  addMember,

  recommend,

  createTag,

  whoCanWatch,

  remindWhoToWatch,

  meeting,

  notificationIssued,
}

class SelectContactsLogic extends GetxController {
  final checkedList = <String, dynamic>{}.obs;
  final defaultCheckedIDList = <String>{}.obs;
  List<String>? excludeIDList;
  late SelAction action;
  late bool openSelectedSheet;
  String? groupID;
  final conversationList = <ConversationInfo>[].obs;
  String? ex;
  final inputCtrl = TextEditingController();

  @override
  void onInit() {
    action = Get.arguments['action'];
    groupID = Get.arguments['groupID'];
    excludeIDList = Get.arguments['excludeIDList'];
    defaultCheckedIDList.addAll(Get.arguments['defaultCheckedIDList'] ?? []);
    checkedList.addAll(Get.arguments['checkedList'] ?? {});
    openSelectedSheet = Get.arguments['openSelectedSheet'];
    ex = Get.arguments['ex'];
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    _queryConversationList();
    if (openSelectedSheet) viewSelectedContactsList();
    super.onReady();
  }

  @override
  bool get isMultiModel => action != SelAction.carte;

  bool get hiddenGroup =>
      action == SelAction.carte ||
      action == SelAction.crateGroup ||
      action == SelAction.addMember ||
      action == SelAction.createTag ||
      action == SelAction.remindWhoToWatch;

  bool get hiddenConversations =>
      action == SelAction.carte ||
      action == SelAction.crateGroup ||
      action == SelAction.addMember ||
      action == SelAction.createTag ||
      action == SelAction.whoCanWatch ||
      action == SelAction.remindWhoToWatch;

  bool get hiddenOrganization => action == SelAction.whoCanWatch || action == SelAction.remindWhoToWatch;

  bool get hiddenTagGroup =>
      action == SelAction.forward ||
      action == SelAction.carte ||
      action == SelAction.crateGroup ||
      action == SelAction.addMember ||
      action == SelAction.recommend ||
      action == SelAction.createTag ||
      action == SelAction.whoCanWatch ||
      action == SelAction.remindWhoToWatch ||
      action == SelAction.meeting;

  _queryConversationList() async {
    if (!hiddenConversations) {
      final list = await OpenIM.iMManager.conversationManager.getConversationListSplit(count: 10);
      conversationList.addAll(list);
    }
  }

  static String? parseID(e) {
    if (e is ConversationInfo) {
      return e.isSingleChat ? e.userID : e.groupID;
    } else if (e is GroupInfo) {
      return e.groupID;
    } else if (e is UserInfo || e is FriendInfo || e is UserFullInfo) {
      return e.userID;
    } else if (e is TagInfo) {
      return e.tagID;
    } else {
      return null;
    }
  }

  static String? parseName(e) {
    if (e is ConversationInfo) {
      return e.showName;
    } else if (e is GroupInfo) {
      return e.groupName;
    } else if (e is UserInfo || e is FriendInfo || e is UserFullInfo) {
      return e.nickname;
    } else if (e is TagInfo) {
      return e.tagName;
    } else {
      return null;
    }
  }

  static String? parseFaceURL(e) {
    if (e is ConversationInfo) {
      return e.faceURL;
    } else if (e is GroupInfo) {
      return e.faceURL;
    } else if (e is UserInfo || e is FriendInfo || e is UserFullInfo) {
      return e.faceURL;
    } else {
      return null;
    }
  }

  @override
  bool isChecked(info) => checkedList.containsKey(parseID(info));

  @override
  bool isDefaultChecked(info) => defaultCheckedIDList.contains(parseID(info));

  @override
  Function()? onTap(dynamic info) => isDefaultChecked(info) ? null : () => toggleChecked(info);

  @override
  removeItem(dynamic info) {
    checkedList.remove(parseID(info));
  }

  @override
  toggleChecked(dynamic info) {
    if (isMultiModel) {
      final key = parseID(info);
      if (checkedList.containsKey(key)) {
        checkedList.remove(key);
      } else {
        checkedList.putIfAbsent(key ?? '', () => info);
      }
    } else {
      confirmSelectedItem(info);
    }
  }

  @override
  updateDefaultCheckedList(List<String> userIDList) async {
    if (groupID != null) {
      var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: groupID!,
        userIDList: userIDList,
      );
      defaultCheckedIDList.addAll(list.map((e) => e.userID!));
    }
  }

  String get checkedStrTips => checkedList.values.map(parseName).join('、');

  viewSelectedContactsList() => Get.bottomSheet(
        SelectedContactsListView(),
        isScrollControlled: true,
      );

  selectFromMyFriend() async {
    final result = await AppNavigator.startSelectContactsFromFriends();
    if (null != result) {
      Get.back(result: result);
    }
  }

  selectFromMyGroup() async {
    final result = await AppNavigator.startSelectContactsFromGroup();
    if (null != result) {
      Get.back(result: result);
    }
  }

  selectFromOrganization() async {}

  void selectFromSearch() async {
    final result = await AppNavigator.startSelectContactsFromSearch();
    if (null != result) {
      Get.back(result: result);
    }
  }

  selectTagGroup() async {}

  confirmSelectedList() async {
    if (action == SelAction.forward || action == SelAction.recommend) {
      final sure = await Get.dialog(ForwardHintDialog(
        title: ex ?? '',
        checkedList: checkedList.values.toList(),
        controller: inputCtrl,
      ));
      if (sure == true) {
        Get.back(result: {
          "checkedList": checkedList.values,
          "customEx": inputCtrl.text.trim(),
        });
      }
    } else {
      Get.back(result: checkedList.value);
    }
  }

  confirmSelectedItem(ISUserInfo info) async {
    if (action == SelAction.carte) {
      final sure = await Get.dialog(CustomDialog(
        title: StrRes.sendCarteConfirmHint,
      ));
      if (sure == true) {
        Get.back(result: UserInfo.fromJson(info.toJson()));
      }
    }
  }

  bool get enabledConfirmButton => checkedList.isNotEmpty || action == SelAction.remindWhoToWatch;

  @override
  Widget get checkedConfirmView => isMultiModel ? CheckedConfirmView() : const SizedBox();
}
