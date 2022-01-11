import 'dart:convert';

import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/app_controller.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/pages/home/home_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/im_util.dart';

class ConversationLogic extends GetxController {
  var popCtrl = CustomPopupMenuController();
  var list = <ConversationInfo>[].obs;
  var imLogic = Get.find<IMController>();
  var homeLogic = Get.find<HomeLogic>();
  var appLogic = Get.find<AppController>();

  @override
  void onInit() {
    imLogic.conversationAddedSubject.listen((newList) {
      list.insertAll(0, newList);
      _sortConversationList();
    });
    imLogic.conversationChangedSubject.listen((newList) {
      for (var newValue in newList) {
        list.remove(newValue);
      }
      list.insertAll(0, newList);
      _sortConversationList();
    });
    super.onInit();
  }

  @override
  void onReady() {
    getConversationListSplit();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getConversationId(int index) {
    var info = list.elementAt(index);
    return info.conversationID;
  }

  /// 获取会话
  void getConversationListSplit() {
    OpenIM.iMManager.conversationManager
        .getConversationListSplit(
          offset: 0,
          count: 40,
        )
        .then((value) => list..assignAll(value));
  }

  /// 标记会话已读
  void markMessageHasRead(int index) {
    var info = list.elementAt(index);
    _markMessageHasRead(
      uid: info.userID,
      gid: info.groupID,
      unreadCount: info.unreadCount!,
    );
  }

  /// 置顶会话
  void pinConversation(int index) async {
    var info = list.elementAt(index);
    OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info.conversationID,
      isPinned: !(info.isPinned == 1),
    );
  }

  /// 删除会话
  void deleteConversation(int index) async {
    var info = list.elementAt(index);
    await OpenIM.iMManager.conversationManager.deleteConversation(
      conversationID: info.conversationID,
    );
    list.removeAt(index);
  }

  /// 设置草稿
  void setConversationDraft({required String cid, required String draftText}) {
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: cid,
      draftText: draftText,
    );
  }

  /// 解析草稿
  String? getPrefixText(int index) {
    var info = list.elementAt(index);
    String? prefix;
    if (null != info.draftText && '' != info.draftText) {
      var map = json.decode(info.draftText!);
      String text = map['text'];
      if (text.isNotEmpty) {
        prefix = '[${StrRes.draftText}]';
      }
    } else if (info.latestMsg?.contentType == MessageType.at_text) {
      try {
        Map map = json.decode(info.latestMsg!.content!);
        String text = map['text'];
        // bool isAtSelf = map['isAtSelf'];
        bool isAtSelf = text.contains('@${OpenIM.iMManager.uid} ');
        if (isAtSelf == true) {
          prefix = '[@${StrRes.you}]';
        }
      } catch (e) {}
    }
    return prefix;
  }

  Map<String, String> getAtUserMap(int index) {
    var info = list.elementAt(index);
    if (info.isGroupChat) {
      Map<String, String> map =
          DataPersistence.getAtUserMap(info.groupID!)?.cast() ?? {};
      return map;
    }
    return {};
  }

  /// 解析消息内容
  String getMsgContent(int index) {
    var info = list.elementAt(index);
    if (null != info.draftText && '' != info.draftText) {
      var map = json.decode(info.draftText!);
      String text = map['text'];
      if (text.isNotEmpty) {
        // Map<String, dynamic> atMap = map['at'];
        // print('text:$text  atMap:$atMap');
        // atMap.forEach((uid, uname) {
        //   text = text.replaceAll(uid, uname);
        // });
        return text;
      }
    }

    if (null == info.latestMsg) return "";

    if (info.latestMsg?.contentType == MessageType.picture) {
      return '[${StrRes.picture}]';
    } else if (info.latestMsg?.contentType == MessageType.video) {
      return '[${StrRes.video}]';
    } else if (info.latestMsg?.contentType == MessageType.voice) {
      return '[${StrRes.voice}]';
    } else if (info.latestMsg?.contentType == MessageType.file) {
      return '[${StrRes.file}]';
    } else if (info.latestMsg?.contentType == MessageType.location) {
      return '[${StrRes.location}]';
    } else if (info.latestMsg?.contentType == MessageType.merger) {
      return '[${StrRes.chatRecord}]';
    } else if (info.latestMsg?.contentType == MessageType.card) {
      return '[${StrRes.carte}]';
    } else if (info.latestMsg?.contentType == MessageType.revoke) {
      if (info.latestMsg?.sendID == OpenIM.iMManager.uid) {
        return '[${StrRes.you}${StrRes.revokeMsg}]';
      } else {
        return '[${info.latestMsg!.senderNickName}${StrRes.revokeMsg}]';
      }
    } else if (info.latestMsg?.contentType == MessageType.at_text) {
      String text = info.latestMsg!.content!;
      try {
        Map map = json.decode(text);
        text = map['text'];
        // text = text.replaceAll('@${OpenIM.iMManager.uid} ', '');
        return text;
      } catch (e) {}
      return text;
    } else if (info.latestMsg?.contentType == MessageType.quote) {
      return info.latestMsg?.quoteElem?.text ?? "";
    } else if (info.latestMsg?.contentType == MessageType.text) {
      return info.latestMsg?.content?.trim() ?? '';
    } else {
      var text;
      try {
        var content = json.decode(info.latestMsg!.content!);
        text = content['defaultTips'];
      } catch (e) {
        text = json.encode(info.latestMsg);
      }
      return text;
    }
  }

  // String text = info.latestMsg?.content?.trim() ?? '';
  // if (text.contains("\"defaultTips\":")) {
  //   try {
  //     Map map = json.decode(text);
  //     return map['defaultTips'];
  //   } catch (e) {}
  // }

  /// 头像
  String? getAvatar(int index) {
    var info = list.elementAt(index);
    return info.faceUrl;
  }

  bool isGroupChat(int index) {
    var info = list.elementAt(index);
    return info.isGroupChat;
  }

  /// 显示名
  String getShowName(int index) {
    var info = list.elementAt(index);
    if (info.showName == null || info.showName.isBlank!) {
      return info.userID!;
    }
    return info.showName!;
  }

  /// 时间
  String getTime(int index) {
    var info = list.elementAt(index);
    return IMUtil.getChatTimeline(info.latestMsgSendTime!);
  }

  /// 未读数
  int getUnreadCount(int index) {
    var info = list.elementAt(index);
    return info.unreadCount ?? 0;
  }

  bool existUnreadMsg(int index) {
    return getUnreadCount(index) > 0;
  }

  /// 判断置顶
  bool isPinned(int index) {
    var info = list.elementAt(index);
    return info.isPinned == 1;
  }

  void toAddFriend() {
    AppNavigator.startAddFriend();
  }

  void toAddGroup() {
    AppNavigator.startAddGroupBySearch();
  }

  void createGroup() {
    AppNavigator.createGroup();
  }

  void toScanQrcode() {
    AppNavigator.startScanQrcode();
  }

  void toViewCallRecords() {
    AppNavigator.startCallRecords();
  }

  /// 聊天
  void toChat(int index) async {
    var info = list.elementAt(index);
    startChat(
      uid: info.userID,
      gid: info.groupID,
      name: info.showName,
      icon: info.faceUrl,
      oldDraftText: info.draftText,
      conversationID: info.conversationID,
      unreadCount: info.unreadCount!,
    );
  }

  /// 从其他界面进入聊天界面（非会话界面进入聊天界面）
  void startChat({
    int type = 0,
    String? uid,
    String? gid,
    String? name,
    String? icon,
    String? oldDraftText,
    String? conversationID,
    int? unreadCount,
  }) async {
    ConversationInfo? info;

    // 获取会话信息，若不存在则创建
    if (null == conversationID) {
      info = await OpenIM.iMManager.conversationManager.getSingleConversation(
        sourceID: uid == null ? gid! : uid,
        sessionType: uid == null ? 2 : 1,
      );
    }

    // 打开聊天窗口，关闭返回草稿
    var newDraftText = await AppNavigator.startChat(
      type: type,
      uid: uid,
      gid: gid,
      name: name,
      icon: icon,
      draftText: oldDraftText ?? info?.draftText,
    );

    _markMessageHasRead(
      uid: uid,
      gid: gid,
      unreadCount: unreadCount ?? info!.unreadCount!,
    );

    _setupDraftText(
      conversationID: conversationID ?? info!.conversationID,
      oldDraftText: oldDraftText ?? info!.draftText!,
      newDraftText: newDraftText,
    );
    // 回到会话列表
    // homeLogic.switchTab(0);
  }

  /// 清空未读消息数
  void _markMessageHasRead({String? uid, String? gid, int unreadCount = 0}) {
    if (unreadCount > 0) {
      if (uid != null && uid.isBlank == false) {
        OpenIM.iMManager.conversationManager.markSingleMessageHasRead(
          userID: uid,
        );
      } else {
        OpenIM.iMManager.conversationManager.markGroupMessageHasRead(
          groupID: gid!,
        );
      }
    }
  }

  /// 设置草稿
  void _setupDraftText({
    required String conversationID,
    required String oldDraftText,
    required String newDraftText,
  }) {
    if (oldDraftText.isEmpty && newDraftText.isEmpty) {
      return;
    }

    // 保存草稿
    print('draftText:$newDraftText');
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversationID,
      draftText: newDraftText,
    );
  }

  /// 自定义会话列表排序规则
  void _sortConversationList() {
    OpenIM.iMManager.conversationManager.simpleSort(list);
  }
}
