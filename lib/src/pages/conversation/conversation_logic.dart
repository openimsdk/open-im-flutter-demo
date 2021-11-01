import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/date_util.dart';

class ConversationLogic extends GetxController {
  var popCtrl = CustomPopupMenuController();
  var list = <ConversationInfo>[].obs;
  var imLogic = Get.find<IMController>();

  @override
  void onInit() {
    imLogic.conversationSubject.listen((newList) {
      // getAllConversationList();
      list.assignAll(newList);
    });
    super.onInit();
  }

  @override
  void onReady() {
    getAllConversationList();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toChat(int index) async {
    var info = list.elementAt(index);
    var draftText = await AppNavigator.startChat(
        uid: info.userID,
        gid: info.groupID,
        name: info.showName,
        icon: info.faceUrl,
        draftText: info.draftText);
    // var draftText = await Get.toNamed(
    //   AppRoutes.CHAT,
    //   // () => ChatPage(),
    //   // binding: ChatBinding(),
    //   arguments: {
    //     "uid": info.userID,
    //     "gid": info.groupID,
    //     "name": info.showName,
    //     "icon": info.faceUrl,
    //     "draftText": info.draftText
    //   },
    // );
    markMessageHasRead(index);
    // Get.toNamed(AppRoutes.CHAT);
    // if (null != draftText && draftText != "") {}
    print('draftText:$draftText');
    setConversationDraft(
      cid: info.conversationID,
      draftText: draftText,
    );
  }

  /// 获取会话
  void getAllConversationList() {
    OpenIM.iMManager.conversationManager
        .getAllConversationList()
        .then((value) => list
          ..clear()
          ..addAll(value));
  }

  /// 标记会话已读
  void markMessageHasRead(int index) {
    var info = list.elementAt(index);
    if (info.userID != null && info.userID.isBlank == false) {
      OpenIM.iMManager.conversationManager.markSingleMessageHasRead(
        userID: info.userID!,
      );
    } else {
      OpenIM.iMManager.conversationManager.markGroupMessageHasRead(
        groupID: info.groupID!,
      );
    }
  }

  /// 置顶会话
  void pinConversation(int index) {
    var info = list.elementAt(index);
    OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info.conversationID,
      isPinned: !(info.isPinned == 1),
    );
  }

  /// 删除会话
  void deleteConversation(int index) {
    var info = list.elementAt(index);
    OpenIM.iMManager.conversationManager.deleteConversation(
      conversationID: info.conversationID,
    );
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
        Map map = json.decode(info.latestMsg?.content?.trim() ?? '');
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

  /// 解析消息内容
  String getMsgContent(int index) {
    var info = list.elementAt(index);
    if (null != info.draftText && '' != info.draftText) {
      var map = json.decode(info.draftText!);
      String text = map['text'];
      if (text.isNotEmpty) {
        Map<String, dynamic> atMap = map['at'];
        print('text:$text  atMap:$atMap');
        atMap.forEach((uid, uname) {
          text = text.replaceAll(uid, uname);
        });
        return text;
      }
    }
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
        return '"[${info.latestMsg!.senderNickName}"${StrRes.revokeMsg}]';
      }
    } else if (info.latestMsg?.contentType == MessageType.at_text) {
      String text = info.latestMsg!.content!;
      try {
        Map map = json.decode(text);
        text = map['text'];
        text = text.replaceAll('@${OpenIM.iMManager.uid} ', '');
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
    return DateUtil.getChatTime(info.latestMsgSendTime!);
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
    // Get.toNamed(AppRoutes.ADD_FRIEND);
  }

  void createGroup() {
    AppNavigator.startSelectContacts(
      action: SelAction.CRATE_GROUP,
      defaultCheckedUidList: [OpenIM.iMManager.uid],
    );
    // Get.toNamed(
    //   AppRoutes.SELECT_CONTACTS,
    //   arguments: {
    //     'action': SelAction.CRATE_GROUP,
    //     'uidList': [OpenIM.iMManager.uid]
    //   },
    // );
  }

  void toScanQrcode() {
    AppNavigator.startScanQrcode();
  }

  void toViewCallRecords() {
    AppNavigator.startCallRecords();
  }
}
