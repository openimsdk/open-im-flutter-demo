import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/models/contacts_info.dart';
import 'package:openim_enterprise_chat/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/data_persistence.dart';
import 'package:openim_enterprise_chat/src/utils/date_util.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';
import 'package:openim_enterprise_chat/src/widgets/bottom_sheet_view.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';
import 'package:openim_enterprise_chat/src/widgets/preview_merge_msg.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChatLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var inputCtrl = TextEditingController();
  var focusNode = FocusNode();
  var autoCtrl = AutoScrollController();

  /// Click on the message to process voice playback, video playback, picture preview, etc.
  final clickSubject = rx.PublishSubject<int>();

  ///
  final forceCloseToolbox = rx.PublishSubject<bool>();

  /// The status of message sending,
  /// there are two kinds of success or failure, true success, false failure
  final msgSendStatusSubject = rx.PublishSubject<MsgStreamEv<bool>>();

  /// The progress of sending messages, such as the progress of uploading pictures, videos, and files
  final msgSendProgressSubject = rx.PublishSubject<MsgStreamEv<int>>();

  /// Download progress of pictures, videos, and files
  final downloadProgressSubject = rx.PublishSubject<MsgStreamEv<double>>();

  bool get isSingleChat => null != uid && uid!.trim().isNotEmpty;

  bool get isGroupChat => null != gid && gid!.trim().isNotEmpty;

  String? uid;
  String? gid;
  var name = ''.obs;
  var icon = ''.obs;
  var messageList = <Message>[].obs;
  var lastTime;
  Timer? typingTimer;
  var typing = false.obs;
  var intervalSendTypingMsg = IntervalDo();
  Message? quoteMsg;
  var quoteContent = "".obs;
  var multiSelMode = false.obs;
  var multiSelList = <Message>[].obs;
  var _borderRadius = BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
  );

  var atUserNameMappingMap = <String, String>{};
  var atUserInfoMappingMap = <String, UserInfo>{};
  var curMsgAtUser = <String>[];

  var _uuid = Uuid();
  var listViewKey = '1124'.obs;

  bool isCurrentChat(Message message) {
    var senderId = message.sendID;
    var groupId = message.groupID;
    var sessionType = message.sessionType;
    var isCurSingleChat = sessionType == 1 && isSingleChat && senderId == uid;
    var isCurGroupChat = sessionType == 2 && isGroupChat && gid == groupId;
    return isCurSingleChat || isCurGroupChat;
  }

  void scrollBottom() {
    // var index = messageList.length - 1;
    // if (index > 0)
    //   // todo
    //   Future.delayed(Duration(milliseconds: 400), () {
    //     autoCtrl.scrollToIndex(index /*,duration: Duration(milliseconds: 1)*/);
    //   });
    print('---------------offset---------${autoCtrl.offset}');
    // 重置listview替代滚动效果
    if (autoCtrl.offset != 0) {
      listViewKey.value = _uuid.v4();
    }
  }

  @override
  void onReady() {
    getAtMappingMap();
    getHistoryMsgList();
    readDraftText();
    super.onReady();
  }

  @override
  void onInit() {
    var arguments = Get.arguments;
    uid = arguments['uid'];
    gid = arguments['gid'];
    name.value = arguments['name'];
    icon.value = arguments['icon'];
    // 新增消息监听
    imLogic.onRecvNewMessage = (Message message) {
      // 如果是当前窗口的消息
      if (isCurrentChat(message)) {
        // 对方正在输入消息
        if (message.contentType == MessageType.typing) {
          if (message.content == 'yes') {
            // 对方正在输入
            if (null == typingTimer) {
              typing.value = true;
              typingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
                // 两秒后取消定时器
                typing.value = false;
                typingTimer?.cancel();
                typingTimer = null;
              });
            }
          } else {
            // 对方停止输入
            typing.value = false;
            typingTimer?.cancel();
            typingTimer = null;
          }
        } else {
          if (!messageList.contains(message)) {
            // messageList.insert(0, message);
            messageList.add(message);
            scrollBottom();
          }
        }
      }
    };
    // 已被撤回消息监听
    imLogic.onRecvMessageRevoked = (String msgId) {
      messageList.removeWhere((e) => e.clientMsgID == msgId);
    };
    // 消息已读回执监听
    var refresh = false;
    imLogic.onRecvC2CReadReceipt = (List<HaveReadInfo> list) {
      try {
        var info = list.firstWhere((read) => read.uid == uid);
        messageList.forEach((e) {
          if (info.msgIDList?.contains(e.clientMsgID) == true) {
            e.isRead = true;
            refresh = true;
          }
        });
      } catch (e) {}
      if (refresh) {
        refresh = false;
        messageList.refresh();
      }
    };
    // 消息发送进度
    imLogic.onMsgSendProgress = (String msgId, int progress) {
      msgSendProgressSubject.addSafely(
        MsgStreamEv<int>(msgId: msgId, value: progress),
      );
    };

    // 有新成员进入
    imLogic.onMemberEnter = (groupId, list) {
      if (groupId == gid) {
        _putMemberInfo(list);
      }
    };
    // 自定义消息点击事件
    clickSubject.listen((index) {
      print('index:$index');
      parseClickEvent(indexOfMessage(index));
    });

    // 输入框监听
    inputCtrl.addListener(() {
      intervalSendTypingMsg.run(
        fuc: () => sendTypingMsg(focus: true),
        milliseconds: 2000,
      );
      clearCurAtMap();
    });

    // 输入框聚焦
    focusNode.addListener(() {
      focusNodeChanged(focusNode.hasFocus);
    });

    // 群信息变化
    imLogic.groupInfoUpdatedSubject.listen((value) {
      if (gid == value.groupID) {
        name.value = value.groupName ?? '';
        icon.value = value.faceUrl ?? '';
      }
    });

    // 好友信息变化
    imLogic.friendInfoChangedSubject.listen((value) {
      if (uid == value.uid) {
        name.value = value.getShowName();
        icon.value = value.icon ?? '';
      }
    });
    super.onInit();
  }

  void chatSetup() {
    if (null != uid && uid!.isNotEmpty) {
      AppNavigator.startChatSetup(
          uid: uid!, name: name.value, icon: icon.value);
    } else if (null != gid && gid!.isNotEmpty) {
      AppNavigator.startGroupSetup(
          gid: gid!, name: name.value, icon: icon.value);
    }
  }

  void clearCurAtMap() {
    curMsgAtUser.removeWhere((uid) => !inputCtrl.text.contains('@$uid '));
  }

  // 用户id/用户名映射表
  // 获取组成员，并保存id跟name
  void getAtMappingMap() async {
    if (isGroupChat) {
      var result = await OpenIM.iMManager.groupManager.getGroupMemberList(
        groupId: gid!,
      );
      _putMemberInfo(result.data);
    }
  }

  /// 记录群成员信息
  void _putMemberInfo(List<GroupMembersInfo>? list) {
    list?.forEach((member) {
      atUserNameMappingMap[member.userId!] = member.nickName!;
      atUserInfoMappingMap[member.userId!] = UserInfo(
        uid: member.userId!,
        name: member.nickName,
        icon: member.faceUrl,
      );
    });
    atUserNameMappingMap[OpenIM.iMManager.uid] = StrRes.you;
    atUserInfoMappingMap[OpenIM.iMManager.uid] = OpenIM.iMManager.uInfo;
    DataPersistence.putAtUserMap(gid!, atUserNameMappingMap);
  }

  /// 获取历史聊天记录
  void getHistoryMsgList() {
    OpenIM.iMManager.messageManager
        .getHistoryMessageList(
          userID: uid,
          groupID: gid,
          count: 100,
        )
        // .then((list) => IMUtil.calChatTimeInterval(list))
        .then((list) => messageList..assignAll(list))
    // .then((list) => messageList..assignAll(list.reversed))
        .whenComplete(() => scrollBottom());
  }

  /// 发送文字内容，包含普通内容，引用回复内容，@内容
  void sendTextMsg() async {
    var content = inputCtrl.text;
    if (content.isEmpty) return;
    var message;
    if (curMsgAtUser.isNotEmpty) {
      // 发送 @ 消息
      message = await OpenIM.iMManager.messageManager.createTextAtMessage(
        text: content,
        atUidList: curMsgAtUser,
      );
    } else if (quoteMsg != null) {
      // 发送引用消息
      message = await OpenIM.iMManager.messageManager.createQuoteMessage(
        text: content,
        quoteMsg: quoteMsg!,
      );
    } else {
      // 发送普通消息
      message = await OpenIM.iMManager.messageManager.createTextMessage(
        text: content,
      );
    }
    _sendMessage(message);
  }

  /// 发送图片
  void sendPicture({required String path}) async {
    var message =
        await OpenIM.iMManager.messageManager.createImageMessageFromFullPath(
      imagePath: path,
    );
    _sendMessage(message);
  }

  /// 发送语音
  void sendVoice({required int duration, required String path}) async {
    var message =
        await OpenIM.iMManager.messageManager.createSoundMessageFromFullPath(
      soundPath: path,
      duration: duration,
    );
    _sendMessage(message);
  }

  ///  发送视频
  void sendVideo({
    required String videoPath,
    required String mimeType,
    required int duration,
    required String thumbnailPath,
  }) async {
    var message =
        await OpenIM.iMManager.messageManager.createVideoMessageFromFullPath(
      videoPath: videoPath,
      videoType: mimeType,
      duration: duration,
      snapshotPath: thumbnailPath,
    );
    _sendMessage(message);
  }

  /// 发送文件
  void sendFile({required String filePath, required String fileName}) async {
    var message =
        await OpenIM.iMManager.messageManager.createFileMessageFromFullPath(
      filePath: filePath,
      fileName: fileName,
    );
    _sendMessage(message);
  }

  /// 发送位置
  void sendLocation({
    required dynamic location,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createLocationMessage(
      latitude: location['latitude'],
      longitude: location['longitude'],
      description: location['description'],
    );
    _sendMessage(message);
  }

  /// 转发
  void sendForwardMsg(int index, {String? userId, String? groupId}) async {
    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
      message: indexOfMessage(index),
    );
    _sendMessage(message, userId: userId, groupId: groupId);
  }

  /// 合并转发
  void sendMergeMsg({
    String? userId,
    String? groupId,
  }) async {
    var summaryList = <String>[];
    var title;
    for (var msg in multiSelList) {
      summaryList.add('${msg.senderNickName}：${IMUtil.parseMsg(msg)}');
      if (summaryList.length >= 2) break;
    }
    if (isGroupChat) {
      title = "群聊${StrRes.chatRecord}";
    } else {
      var partner1 = OpenIM.iMManager.uInfo.getShowName();
      var partner2 = name.value;
      title = "$partner1和$partner2${StrRes.chatRecord}";
    }
    var message = await OpenIM.iMManager.messageManager.createMergerMessage(
      messageList: multiSelList,
      title: title,
      summaryList: summaryList,
    );
    _sendMessage(message, userId: userId, groupId: groupId);
  }

  /// 提示对方正在输入
  void sendTypingMsg({bool focus = false}) async {
    if (isSingleChat) {
      OpenIM.iMManager.messageManager.typingStatusUpdate(
        userID: uid!,
        typing: focus,
      );
    }
  }

  /// 发送名片
  void sendCarte({required String uid, String? name, String? icon}) async {
    var message = await OpenIM.iMManager.messageManager.createCardMessage(
      data: {"uid": uid, 'name': name, 'icon': icon},
    );
    _sendMessage(message);
  }

  void sendCustomMsg() {
    /* OpenIM.iMManager.messageManager.createCustomMessage(
      data: data,
      extension: extension,
      description: description,
    );*/
  }

  void _sendMessage(Message message, {String? userId, String? groupId}) {
    log('send : ${json.encode(message)}');
    if (null == userId && null == groupId) {
      // messageList.insert(0, message);
      messageList.add(message);
      scrollBottom();
    }
    print('uid:$uid  userId:$userId  gid:$gid    groupId:$groupId');
    _reset();
    OpenIM.iMManager.messageManager
        .sendMessage(
          message: message,
          userID: userId ?? uid,
          groupID: groupId ?? gid,
        )
        .then((value) => _sendSucceeded(message))
        .catchError((e) => _senFailed(message, e))
        .whenComplete(() => _completed());
  }

  ///  消息发送成功
  void _sendSucceeded(Message message) {
    message.status = MessageStatus.succeeded;
    msgSendStatusSubject.addSafely(MsgStreamEv<bool>(
      msgId: message.clientMsgID!,
      value: true,
    ));
  }

  ///  消息发送失败
  void _senFailed(Message message, e) {
    print('send failed e :$e');
    message.status = MessageStatus.failed;
    msgSendStatusSubject.addSafely(MsgStreamEv<bool>(
      msgId: message.clientMsgID!,
      value: false,
    ));
  }

  void _reset() {
    setQuoteMsg(-1);
    closeMultiSelMode();
    inputCtrl.clear();
  }

  /// todo
  void _completed() {
    messageList.refresh();
    // setQuoteMsg(-1);
    // closeMultiSelMode();
    // inputCtrl.clear();
  }

  /// 设置被回复的消息体
  void setQuoteMsg(int index) {
    print('quote index:$index');
    if (index == -1) {
      quoteMsg = null;
      quoteContent.value = '';
    } else {
      quoteMsg = indexOfMessage(index);
      var name = quoteMsg!.senderNickName;
      quoteContent.value = "$name：${IMUtil.parseMsg(quoteMsg!)}";
    }
  }

  /// 删除消息
  void deleteMsg(int index) {
    var message = indexOfMessage(index);
    OpenIM.iMManager.messageManager
        .deleteMessageFromLocalStorage(message: message)
        .then((value) => messageList.remove(message));
  }

  void _deleteMsg() {
    multiSelList.forEach((e) {
      OpenIM.iMManager.messageManager
          .deleteMessageFromLocalStorage(message: e)
          .then((value) => messageList.remove(e));
    });
    closeMultiSelMode();
  }

  /// 撤回消息
  void revokeMsg(int index) async {
    var message = indexOfMessage(index);
    await OpenIM.iMManager.messageManager.revokeMessage(
      message: message,
    );
    message.contentType = MessageType.revoke;
    messageList.refresh();
  }

  /// 转发
  void forward(int index) async {
    var result =
        await AppNavigator.startSelectContacts(action: SelAction.FORWARD);

    if (null != result) {
      sendForwardMsg(index, userId: result['uId'], groupId: result['gId']);
    }
  }

  /// 标记消息为已读
  void markC2CMessageAsRead(int index, Message message, bool visible) {
    if (isSingleChat &&
        visible &&
        !message.isRead! &&
        message.sendID != OpenIM.iMManager.uid) {
      OpenIM.iMManager.messageManager.markC2CMessageAsRead(
        userID: uid!,
        messageIDList: [message.clientMsgID!],
      );
    }
  }

  /// 合并转发
  void mergeForward() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.mergeForward,
            borderRadius: _borderRadius,
            onTap: () async {
              var result = await AppNavigator.startSelectContacts(
                action: SelAction.FORWARD,
              );
              if (null != result) {
                sendMergeMsg(userId: result['uId'], groupId: result['gId']);
              }
            },
          ),
        ],
      ),
      barrierColor: Colors.transparent,
    );
  }

  /// 多选删除
  void mergeDelete() {
    Get.bottomSheet(
      BottomSheetView(items: [
        SheetItem(
          label: StrRes.delete,
          borderRadius: _borderRadius,
          onTap: _deleteMsg,
        ),
      ]),
      barrierColor: Colors.transparent,
    );
  }

  void multiSelMsg(int index, bool checked) {
    var msg = indexOfMessage(index);
    if (checked) {
      multiSelList.add(msg);
      multiSelList.sort((a, b) {
        if (a.createTime! > b.createTime!) {
          return 1;
        } else if (a.createTime! < b.createTime!) {
          return -1;
        } else {
          return 0;
        }
      });
    } else {
      multiSelList.remove(msg);
    }
  }

  void openMultiSelMode(int index) {
    multiSelMode.value = true;
    multiSelMsg(index, true);
  }

  void closeMultiSelMode() {
    multiSelMode.value = false;
    multiSelList.clear();
  }

  /// 触摸其他地方强制关闭工具箱
  void closeToolbox() {
    forceCloseToolbox.addSafely(true);
  }

  /// 打开地图
  void onTapLocation() async {
    var location = await Get.to(ChatWebViewMap());
    print(location);
    if (null != location) {
      sendLocation(location: location);
    }
  }

  /// 打开相册
  void onTapAlbum() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
      requestType: RequestType.common,
    );
    if (null != assets) {
      for (var asset in assets) {
        _handleAssets(asset);
      }
    }
  }

  /// 打开相机
  void onTapCamera() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      Get.context!,
      enableRecording: true,
    );
    _handleAssets(entity);
  }

  /// 打开系统文件浏览器
  void onTapFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      // type: FileType.custom,
      // allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      for (var file in result.files) {
        sendFile(filePath: file.path, fileName: file.name);
      }
    } else {
      // User canceled the picker
    }
  }

  /// 名片
  void onTapCarte() async {
    var result =
        await AppNavigator.startSelectContacts(action: SelAction.CARTE);
    if (null != result) {
      sendCarte(
        uid: result['uId'],
        name: result['uName'],
        icon: result['uIcon'],
      );
    }
  }

  void _handleAssets(AssetEntity? asset) async {
    if (null != asset) {
      print('--------assets type-----${asset.type}');
      var path = (await asset.file)!.path;
      switch (asset.type) {
        case AssetType.image:
          sendPicture(path: path);
          break;
        case AssetType.video:
          var trulyW = asset.width;
          var trulyH = asset.height;
          var scaleW = 100.w;
          var scaleH = scaleW * trulyH / trulyW;
          var data = await asset.thumbDataWithSize(
            scaleW.toInt(),
            scaleH.toInt(),
          );
          final result = await ImageGallerySaver.saveImage(data!);
          var thumbnailPath = result['filePath'];
          var start = thumbnailPath.indexOf('/storage');
          thumbnailPath = thumbnailPath.substring(start);
          sendVideo(
            videoPath: path,
            mimeType: asset.mimeType ?? CommonUtil.getMediaType(path) ?? '',
            duration: asset.duration,
            thumbnailPath: thumbnailPath,
          );
          // sendVoice(duration: asset.duration, path: path);
          break;
        default:
          break;
      }
    }
  }

  /// 处理消息点击事件
  void parseClickEvent(Message msg) async {
    log("message:${json.encode(msg)}");
    if (msg.contentType == MessageType.picture) {
      IMUtil.openPicture(msg);
    } else if (msg.contentType == MessageType.video) {
      IMUtil.openVideo(msg);
    } else if (msg.contentType == MessageType.file) {
      IMUtil.openFile(msg);
      // OpenFile.open(filePath);
    } else if (msg.contentType == MessageType.card) {
      var info = ContactsInfo.fromJson(json.decode(msg.content!));
      AppNavigator.startFriendInfo(info: info);
    } else if (msg.contentType == MessageType.merger) {
      Get.to(
        () => PreviewMergeMsg(
          title: msg.mergeElem!.title!,
          messageList: msg.mergeElem!.multiMessage!,
        ),
        preventDuplicates: false,
      );
    }
  }

  /// 点击引用消息
  void onTapQuoteMsg(index) {
    var msg = indexOfMessage(index);
    parseClickEvent(msg.quoteElem!.quoteMessage!);
  }

  /// 拨视频或音频
  void call() {
    if (isGroupChat) {
      IMWidget.openIMGroupCallSheet(gid: gid!);
      return;
    }
    IMWidget.openIMCallSheet(uid: uid!, name: name.value, icon: icon.value);
  }

  /// 群聊天长按头像为@用户
  void onLongPressLeftAvatar(int index) {
    var msg = indexOfMessage(index);
    if (isGroupChat) {
      var uid = msg.sendID!;
      var uname = msg.senderNickName;
      if (curMsgAtUser.contains(uid)) return;
      curMsgAtUser.add(uid);
      // 在光标出插入内容
      // 先保存光标前和后内容
      var cursor = inputCtrl.selection.base.offset;
      if (cursor < 0) cursor = 0;
      print('===================cursor:$cursor');
      // 光标前面的内容
      var start = inputCtrl.text.substring(0, cursor);
      print('===================start:$start');
      // 光标后面的内容
      var end = inputCtrl.text.substring(cursor);
      print('===================end:$end');
      var at = '@$uid ';
      inputCtrl.text = '$start$at$end';
      inputCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: '$start$at'.length,
      ));
      print('$curMsgAtUser');
    }
  }

  void onTapLeftAvatar(int index) {
    var msg = indexOfMessage(index);
    var info = ContactsInfo.fromJson({
      'uid': msg.sendID!,
      'name': msg.senderNickName,
      'icon': msg.senderFaceUrl,
      'flag': 1,
    });
    AppNavigator.startFriendInfo(info: info);
    // Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
  }

  void clickAtText(id) {
    if (null != atUserInfoMappingMap[id]) {
      AppNavigator.startFriendInfo(info: atUserInfoMappingMap[id]);
    }
  }

  void clickUrlText(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  /// 读取草稿
  void readDraftText() {
    var draftText = Get.arguments['draftText'];
    print('readDraftText:$draftText');
    if (null != draftText && "" != draftText) {
      var map = json.decode(draftText!);
      String text = map['text'];
      // String? quoteMsgId = map['quoteMsgId'];
      Map<String, dynamic> atMap = map['at'];
      print('text:$text  atMap:$atMap');
      atMap.forEach((key, value) {
        if (!curMsgAtUser.contains(key)) curMsgAtUser.add(key);
        atUserNameMappingMap.putIfAbsent(key, () => value);
      });
      inputCtrl.text = text;
      inputCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: text.length,
      ));
      // if (null != quoteMsgId) {
      //   var index = messageList.indexOf(Message()..clientMsgID = quoteMsgId);
      //   print('quoteMsgId index:$index  length:${messageList.length}');
      //   setQuoteMsg(index);
      //   print('quoteMsgId index:$index  length:${messageList.length}');
      // }
      if (text.isNotEmpty) {
        focusNode.requestFocus();
      }
    }
  }

  /// 生成草稿draftText
  String createDraftText() {
    var atMap = <String, dynamic>{};
    curMsgAtUser.forEach((uid) {
      atMap[uid] = atUserNameMappingMap[uid];
    });
    return json.encode({
      'text': inputCtrl.text,
      'at': atMap,
      // 'quoteMsgId': quoteMsg?.clientMsgID,
    });
  }

  /// 退出界面前处理
  bool exit() {
    if (multiSelMode.value) {
      closeMultiSelMode();
      return false;
    }
    Get.back(result: createDraftText());
    return true;
  }

  void focusNodeChanged(bool hasFocus) {
    sendTypingMsg(focus: hasFocus);
    if (hasFocus) {
      print('focus:$hasFocus');
      scrollBottom();
    }
  }

  void copy(index) {
    var msg = indexOfMessage(index);
    IMUtil.copy(text: msg.content!);
  }

  Message indexOfMessage(int index) =>
      IMUtil.calChatTimeInterval(messageList).reversed.elementAt(index);

  ValueKey itemKey(int index) => ValueKey(indexOfMessage(index).clientMsgID!);

  @override
  void onClose() {
    // inputCtrl.dispose();
    // focusNode.dispose();
    clickSubject.close();
    forceCloseToolbox.close();
    msgSendStatusSubject.close();
    msgSendProgressSubject.close();
    downloadProgressSubject.close();
    super.onClose();
  }

  String? getShowTime(int index) {
    var info = indexOfMessage(index);
    if (info.ext == true) {
      return DateUtil.getChatTime(info.sendTime!);
    }
    return null;
  }
}
