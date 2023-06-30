import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import 'select_contacts_view.dart';

enum SelAction {
  /// 转发到最近聊天，转发到好友，转发到群里，转发到组织架构
  forward,

  /// 发送名片到该聊天：可从好友，组织架构
  carte,

  /// 创建群聊：可从好友，组织架构
  crateGroup,

  /// 添加群成员：可从好友，组织架构
  addMember,

  /// 推荐：可推荐给最近聊天，好友，群里，组织架构
  recommend,

  /// 创建tag组，可从好友, 组织架构
  createTag,

  /// 朋友圈：可见或部分可见 选择从 好友，群
  whoCanWatch,

  /// 朋友圈：提醒谁看 只有好友
  remindWhoToWatch,

  /// 会议：好友，组织架构，群，最近会话
  meeting,

  /// 下发通知 好友，组织架构，群，标签，最近会话
  notificationIssued,
}

class SelectContactsLogic extends GetxController
    implements OrganizationMultiSelBridge {
  final checkedList = <String, dynamic>{}.obs; // 已经选中的
  final defaultCheckedIDList = <String>{}.obs; // 默认选中，且不能修改
  List<String>? excludeIDList; // 剔除某些数据
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
    PackageBridge.organizationBridge = this;
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    PackageBridge.organizationBridge = null;
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

  /// 隐藏群
  bool get hiddenGroup =>
      action == SelAction.carte ||
      action == SelAction.crateGroup ||
      action == SelAction.addMember ||
      action == SelAction.createTag ||
      action == SelAction.remindWhoToWatch;

  /// 隐藏最近会话
  bool get hiddenConversations =>
      action == SelAction.carte ||
      action == SelAction.crateGroup ||
      action == SelAction.addMember ||
      action == SelAction.createTag ||
      action == SelAction.whoCanWatch ||
      action == SelAction.remindWhoToWatch;

  /// 隐藏组织架构
  bool get hiddenOrganization =>
      action == SelAction.whoCanWatch || action == SelAction.remindWhoToWatch;

  /// 隐藏标签组
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

  /// 最近会话
  _queryConversationList() async {
    if (!hiddenConversations) {
      final list = await OpenIM.iMManager.conversationManager
          .getConversationListSplit(count: 10);
      conversationList.addAll(list);
    }
  }

  static String? parseID(e) {
    if (e is ConversationInfo) {
      return e.isSingleChat ? e.userID : e.groupID;
    } else if (e is GroupInfo) {
      return e.groupID;
    } else if (e is UserInfo) {
      return e.userID;
    } else if (e is DeptMemberInfo) {
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
    } else if (e is UserInfo) {
      return e.nickname;
    } else if (e is DeptMemberInfo) {
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
    } else if (e is UserInfo) {
      return e.faceURL;
    } else if (e is DeptMemberInfo) {
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
  Function()? onTap(dynamic info) =>
      isDefaultChecked(info) ? null : () => toggleChecked(info);

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

  /// 邀请群成员，标记已入群的人员
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

  selectFromOrganization() async {
    // final result = await ONavigator.startSelectContactsFromOrganization();
    // if (null != result) {
    //   Get.back(result: result);
    // }
  }

  void selectFromSearch() async {
    final result = await AppNavigator.startSelectContactsFromSearch();
    if (null != result) {
      Get.back(result: result);
    }
  }

  selectTagGroup() async {
    // final result = await await AppNavigator.startSelectContactsFromTag();
    // if (null != result) {
    //   Get.back(result: result);
    // }
  }

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

  confirmSelectedItem(dynamic info) async {
    if (action == SelAction.carte) {
      final sure = await Get.dialog(CustomDialog(
        title: StrRes.sendCarteConfirmHint,
      ));
      if (sure == true) {
        Get.back(result: info);
      }
    }
  }

  bool get enabledConfirmButton =>
      checkedList.isNotEmpty || action == SelAction.remindWhoToWatch;

  @override
  Widget get checkedConfirmView =>
      isMultiModel ? CheckedConfirmView() : const SizedBox();
}
