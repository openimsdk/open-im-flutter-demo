import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../core/controller/im_controller.dart';

class OANotificationLogic extends GetxController {
  late ConversationInfo info;
  var messageList = <Message>[].obs;
  final pageSize = 40;
  final refreshController = RefreshController(initialRefresh: false);
  final imLogic = Get.find<IMController>();
  int? lastMinSeq;
  bool _isFirstLoad = false;

  @override
  void onInit() {
    info = Get.arguments;

    imLogic.onRecvNewMessage = (Message message) {
      if (message.contentType == MessageType.oaNotification) {
        if (!messageList.contains(message)) messageList.add(message);
      }
    };
    super.onInit();
  }

  @override
  void onReady() {
    loadNotification();
    super.onReady();
  }

  void loadNotification() async {
    final result = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
      conversationID: info.conversationID,
      count: 200,
      startMsg: _isFirstLoad ? null : messageList.firstOrNull,
    );
    if (result.messageList == null || result.messageList!.isEmpty) {
      return refreshController.loadNoData();
    }
    final list = result.messageList!;
    lastMinSeq = result.lastMinSeq;

    if (_isFirstLoad) {
      _isFirstLoad = false;
      messageList.assignAll(list);
    } else {
      messageList.insertAll(0, list);
    }
    if (result.isEnd == true) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
  }

  OANotification parse(Message message) => OANotification.fromJson(json.decode(message.notificationElem!.detail!));

  Size calSize(OANotification oa, double w, double h) {
    final width = 50.w;

    final height = width * h / w;
    print('----${oa.videoElem?.snapshotWidth}---width:$width');
    print('----${oa.videoElem?.snapshotHeight}---height:$height');
    return Size(width, height);
  }
}
