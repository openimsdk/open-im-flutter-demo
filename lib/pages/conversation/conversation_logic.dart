import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/controller/app_controller.dart';
import '../../core/controller/im_controller.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../contacts/add_by_search/add_by_search_logic.dart';
import '../home/home_logic.dart';

class ConversationLogic extends GetxController {
  final popCtrl = CustomPopupMenuController();
  final list = <ConversationInfo>[].obs;
  final imLogic = Get.find<IMController>();
  final homeLogic = Get.find<HomeLogic>();
  final appLogic = Get.find<AppController>();
  final refreshController = RefreshController();
  final tempDraftText = <String, String>{};
  final pageSize = 400;

  final imStatus = IMSdkStatus.connectionSucceeded.obs;
  bool reInstall = false;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  int scrollIndex = -1;
  final onChangeConversations = <ConversationInfo>[];

  @override
  void onInit() {
    getFirstPage();
    imLogic.conversationAddedSubject.listen(onChanged);
    imLogic.conversationChangedSubject.listen(onChanged);
    homeLogic.onScrollToUnreadMessage = scrollTo;
    imLogic.imSdkStatusSubject.listen((value) async {
      final status = value.status;
      final appReInstall = value.reInstall;
      final progress = value.progress;
      imStatus.value = status;

      if (status == IMSdkStatus.syncStart) {
        reInstall = appReInstall;
        if (reInstall) {
          EasyLoading.showProgress(0, status: StrRes.synchronizing);
        }
      }

      Logger.print('IM SDK Status: $status, reinstall: $reInstall, progress: $progress');

      if (status == IMSdkStatus.syncProgress && reInstall) {
        final p = (progress!).toDouble() / 100.0;

        EasyLoading.showProgress(p, status: '${StrRes.synchronizing}(${(p * 100.0).truncate()}%)');
      } else if (status == IMSdkStatus.syncEnded || status == IMSdkStatus.syncFailed) {
        EasyLoading.dismiss();
        if (reInstall) {
          onRefresh();
          reInstall = false;
        }
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    list.clear();
    reInstall = false;
    super.onClose();
  }

  void onChanged(List<ConversationInfo> newList) {
    if (reInstall) {
      onChangeConversations.addAll(newList);
    }
    for (var newValue in newList) {
      Logger.print('======== conversation changed: ${newValue.toJson()} ========');
      list.removeWhere((e) => e.conversationID == newValue.conversationID);
    }

    if (newList.length > pageSize) {
      final tempList = newList;

      while (true) {
        final temp = tempList.sublist(0, pageSize);
        list.insertAll(0, temp);
        _sortConversationList();

        if (tempList.length <= pageSize) {
          break;
        }

        tempList.removeRange(0, pageSize);
      }
    } else {
      list.insertAll(0, newList);
      _sortConversationList();
      Logger.print(
          '======== conversation sort result: ${list.where((e) => e.unreadCount > 0).toList().map((e) => '${e.showName} [${e.conversationID}]: ${e.unreadCount}')} ========');
    }
  }

  void promptSoundOrNotification(ConversationInfo info) {
    if (imLogic.userInfo.value.globalRecvMsgOpt == 0 &&
        info.recvMsgOpt == 0 &&
        info.unreadCount > 0 &&
        info.latestMsg?.sendID != OpenIM.iMManager.userID) {
      appLogic.promptSoundOrNotification(info.latestMsg!.seq!);
    }
  }

  String getConversationID(ConversationInfo info) {
    return info.conversationID;
  }

  void markMessageHasRead(ConversationInfo info) {
    _markMessageHasRead(info);
  }

  void pinConversation(ConversationInfo info) async {
    OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info.conversationID,
      isPinned: !info.isPinned!,
    );
  }

  void deleteConversation(ConversationInfo info) async {
    await OpenIM.iMManager.conversationManager.deleteConversationAndDeleteAllMsg(
      conversationID: info.conversationID,
    );
    list.remove(info);
  }

  void removeConversation(String id) {
    list.removeWhere((e) => e.conversationID == id);
  }

  void setConversationDraft({required String cid, required String draftText}) {
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: cid,
      draftText: draftText,
    );
  }

  String? getPrefixTag(ConversationInfo info) {
    if (info.groupAtType == GroupAtType.groupNotification) {
      return '[${StrRes.groupAc}]';
    }

    return null;
  }

  String getContent(ConversationInfo info) {
    try {
      if (null != info.draftText && '' != info.draftText) {
        var map = json.decode(info.draftText!);
        String text = map['text'];
        if (text.isNotEmpty) {
          return text;
        }
      }

      if (null == info.latestMsg) return "";

      final text = IMUtils.parseNtf(info.latestMsg!, isConversation: true);
      if (text != null) return text;
      if (info.isSingleChat || info.latestMsg!.sendID == OpenIM.iMManager.userID)
        return IMUtils.parseMsg(info.latestMsg!, isConversation: true);

      return "${info.latestMsg!.senderNickname}: ${IMUtils.parseMsg(info.latestMsg!, isConversation: true)} ";
    } catch (e, s) {
      Logger.print('------e:$e s:$s');
    }
    return '[${StrRes.unsupportedMessage}]';
  }

  String? getAvatar(ConversationInfo info) {
    return info.faceURL;
  }

  bool isGroupChat(ConversationInfo info) {
    return info.isGroupChat;
  }

  String getShowName(ConversationInfo info) {
    if (info.showName == null || info.showName.isBlank!) {
      return info.userID!;
    }
    return info.showName!;
  }

  String getTime(ConversationInfo info) {
    return IMUtils.getChatTimeline(info.latestMsgSendTime!);
  }

  int getUnreadCount(ConversationInfo info) {
    return info.unreadCount;
  }

  bool existUnreadMsg(ConversationInfo info) {
    return getUnreadCount(info) > 0;
  }

  bool isPinned(ConversationInfo info) {
    return info.isPinned!;
  }

  bool isNotDisturb(ConversationInfo info) {
    return info.recvMsgOpt != 0;
  }

  bool isUserGroup(int index) => list.elementAt(index).isGroupChat;

  void _markMessageHasRead(
    ConversationInfo conversation,
  ) {
    if (conversation.unreadCount == 0) {
      return;
    }
    OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
      conversationID: conversation.conversationID,
    );
  }

  void _setupDraftText({
    required String conversationID,
    required String oldDraftText,
    required String newDraftText,
  }) {
    if (oldDraftText.isEmpty && newDraftText.isEmpty) {
      return;
    }

    Logger.print('draftText:$newDraftText');
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversationID,
      draftText: newDraftText,
    );
  }

  String? get imSdkStatus {
    switch (imStatus.value) {
      case IMSdkStatus.syncStart:
      case IMSdkStatus.synchronizing:
      case IMSdkStatus.syncProgress:
        return StrRes.synchronizing;
      case IMSdkStatus.syncFailed:
        return StrRes.syncFailed;
      case IMSdkStatus.connecting:
        return StrRes.connecting;
      case IMSdkStatus.connectionFailed:
        return StrRes.connectionFailed;
      case IMSdkStatus.connectionSucceeded:
      case IMSdkStatus.syncEnded:
        return null;
    }
  }

  bool get isFailedSdkStatus =>
      imStatus.value == IMSdkStatus.connectionFailed || imStatus.value == IMSdkStatus.syncFailed;

  void _sortConversationList() => OpenIM.iMManager.conversationManager.simpleSort(list);

  void onRefresh() async {
    late List<ConversationInfo> list;
    try {
      list = await _request();
      this.list.assignAll(list);

      if (list.isEmpty || list.length < pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    } finally {
      refreshController.refreshCompleted();
    }
  }

  static Future<List<ConversationInfo>> getConversationFirstPage() async {
    final result = await OpenIM.iMManager.conversationManager.getConversationListSplit(offset: 0, count: 400);

    return result;
  }

  void getFirstPage() async {
    final result = homeLogic.conversationsAtFirstPage;

    list.assignAll(result);
    _sortConversationList();
  }

  void clearConversations() {
    list.clear();
  }

  _request() async {
    final temp = <ConversationInfo>[];

    while (true) {
      var result = await OpenIM.iMManager.conversationManager.getConversationListSplit(
        offset: temp.length,
        count: pageSize,
      );
      if (onChangeConversations.isNotEmpty) {
        final bSet = Set.from(onChangeConversations);

        Logger.print('replace conversation: [${onChangeConversations.length}], $bSet');

        for (int i = 0; i < result.length; i++) {
          final info = result[i];

          if (bSet.contains(info)) {
            result[i] = onChangeConversations[onChangeConversations.indexOf(info)];
          }
        }
      }
      temp.addAll(result);

      if (result.length < pageSize) {
        break;
      }
    }
    onChangeConversations.clear();

    return temp;
  }

  bool isValidConversation(ConversationInfo info) {
    return info.isValid;
  }

  void scrollTo() {
    if (list.isEmpty) return;

    final positions = itemPositionsListener.itemPositions.value;

    int min = 0;
    if (positions.isNotEmpty) {
      min = (positions
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index);
    }

    var currentIndex = 0;

    for (var i = min + 1; i < list.length; i++) {
      final item = list[i];

      if (item.unreadCount > 0) {
        currentIndex = i;
        break;
      }
    }

    scrollIndex = currentIndex;

    if (scrollIndex == 0) {
      itemScrollController.jumpTo(index: 0);
    } else {
      itemScrollController.scrollTo(index: scrollIndex, duration: const Duration(milliseconds: 300));
    }
  }

  static Future<ConversationInfo> _createConversation({
    required String sourceID,
    required int sessionType,
  }) =>
      LoadingView.singleton.wrap(
          asyncFunction: () => OpenIM.iMManager.conversationManager.getOneConversation(
                sourceID: sourceID,
                sessionType: sessionType,
              ));

  Future<bool> _jumpOANtf(ConversationInfo info) async {
    if (info.conversationType == ConversationType.notification) {
      await AppNavigator.startOANtfList(info: info);
      _markMessageHasRead(info);
      return true;
    }
    return false;
  }

  void toChat({
    bool offUntilHome = true,
    String? userID,
    String? groupID,
    String? nickname,
    String? faceURL,
    int? sessionType,
    ConversationInfo? conversationInfo,
    Message? searchMessage,
  }) async {
    conversationInfo ??= await _createConversation(
      sourceID: userID ?? groupID!,
      sessionType: userID == null ? sessionType! : ConversationType.single,
    );

    if (await _jumpOANtf(conversationInfo)) return;

    await AppNavigator.startChat(
      offUntilHome: offUntilHome,
      draftText: conversationInfo.draftText,
      conversationInfo: conversationInfo,
      searchMessage: searchMessage,
    );

    var newDraftText = tempDraftText[conversationInfo.conversationID];

    _markMessageHasRead(conversationInfo);

    _setupDraftText(
      conversationID: conversationInfo.conversationID,
      oldDraftText: conversationInfo.draftText ?? '',
      newDraftText: newDraftText!,
    );

    bool equal(e) => e.conversationID == conversationInfo?.conversationID;

    var groupAtType = list.firstWhereOrNull(equal)?.groupAtType;
    if (groupAtType != GroupAtType.atNormal) {
      OpenIM.iMManager.conversationManager.resetConversationGroupAtType(
        conversationID: conversationInfo.conversationID,
      );
    }
  }

  scan() => AppNavigator.startScan();

  addFriend() => AppNavigator.startAddContactsBySearch(searchType: SearchType.user);

  createGroup() => AppNavigator.startCreateGroup(defaultCheckedList: [OpenIM.iMManager.userInfo]);

  addGroup() => AppNavigator.startAddContactsBySearch(searchType: SearchType.group);

  void globalSearch() => AppNavigator.startGlobalSearch();
}
