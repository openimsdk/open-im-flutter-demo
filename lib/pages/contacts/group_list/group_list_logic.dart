import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../core/controller/im_controller.dart';
import '../../../core/im_callback.dart';
import '../../conversation/conversation_logic.dart';

class GroupListLogic extends GetxController {
  final imLoic = Get.find<IMController>();
  final iCreateRefreshController = RefreshController(initialRefresh: true);
  final iJoinRefreshController = RefreshController(initialRefresh: true);

  final iCreateGlobalKey = GlobalKey();
  final iJoinGlobalKey = GlobalKey();

  final conversationLogic = Get.find<ConversationLogic>();
  final index = 0.obs;
  final iCreatedList = <GroupInfo>[].obs;
  final iJoinedList = <GroupInfo>[].obs;

  int iCreatedOffset = 0;
  int iJoinedOffset = 0;

  int count = 1000;

  @override
  void onInit() {
    imLoic.imSdkStatusPublishSubject.last.then((con) {
      if (con.status == IMSdkStatus.syncEnded) {
        iCreatedInitial();
        iJoinedInitial();
      }
    });

    iCreatedInitial();
    iJoinedInitial();

    super.onInit();
  }

  void switchTab(i) {
    index.value = i;
  }

  void iCreatedInitial() async {
    iCreatedOffset = 0;
    iCreatedList.clear();
    final length = await initial(iCreate: true, offset: iCreatedOffset);

    iCreateRefreshController.refreshCompleted();

    if (length >= count) {
      iCreatedOffset += length;
    } else {
      iCreateRefreshController.loadNoData();
    }
  }

  void iCreatedLoadMore() async {
    final length = await loadMore(iCreate: true, offset: iCreatedOffset);

    if (length < count) {
      iCreateRefreshController.loadNoData();
    } else {
      iCreateRefreshController.loadComplete();
      iCreatedOffset += length;
    }
  }

  void iJoinedInitial() async {
    iJoinedOffset = 0;
    iJoinedList.clear();
    final length = await initial(iCreate: false, offset: iJoinedOffset);

    iJoinRefreshController.refreshCompleted();

    if (length >= count) {
      iJoinedOffset += length;
    } else {
      iJoinRefreshController.loadNoData();
    }
  }

  void iJoinedLoadMore() async {
    final length = await loadMore(iCreate: false, offset: iJoinedOffset);

    if (length < count) {
      iJoinRefreshController.loadNoData();
    } else {
      iJoinRefreshController.loadComplete();
      iJoinedOffset += length;
    }
  }

  Future<int> initial({bool iCreate = true, int offset = 0}) async {
    final list = await OpenIM.iMManager.groupManager.getJoinedGroupListPage(offset: offset, count: count);

    int iCreatedCount = 0;
    int iJoinedCount = 0;

    if (iCreate) {
      final result = list.where((e) => e.ownerUserID == OpenIM.iMManager.userID);
      iCreatedList.addAll(result);
      iCreatedCount = result.length;
    } else {
      final result = list.where((e) => e.ownerUserID != OpenIM.iMManager.userID);
      iJoinedList.addAll(result);
      iJoinedCount = result.length;
    }

    return iCreate ? iCreatedCount : iJoinedCount;
  }

  Future<int> loadMore({bool iCreate = true, int offset = 0}) async {
    final list = await OpenIM.iMManager.groupManager.getJoinedGroupListPage(offset: offset, count: count);

    int iCreatedCount = 0;
    int iJoinedCount = 0;

    if (iCreate) {
      final result = list.where((e) => e.ownerUserID == OpenIM.iMManager.userID);
      iCreatedList.addAll(result);
      iCreatedCount = result.length;
    } else {
      final result = list.where((e) => e.ownerUserID != OpenIM.iMManager.userID);
      iJoinedList.addAll(result);
      iJoinedCount = result.length;
    }

    return iCreate ? iCreatedCount : iJoinedCount;
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

  void searchGroup() => AppNavigator.startSearchGroup();
}
