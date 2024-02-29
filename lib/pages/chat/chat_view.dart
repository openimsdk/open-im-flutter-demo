import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'chat_logic.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>(tag: GetTags.chat);

  ChatPage({super.key});

  Widget _buildItemView(Message message) => ChatItemView(
        key: logic.itemKey(message),
        message: message,
        allAtMap: logic.getAtMapping(message),
        timelineStr: logic.getShowTime(message),
        sendStatusSubject: logic.sendStatusSub,
        sendProgressSubject: logic.sendProgressSub,
        leftNickname: logic.getNewestNickname(message),
        leftFaceUrl: logic.getNewestFaceURL(message),
        rightNickname: OpenIM.iMManager.userInfo.nickname,
        rightFaceUrl: OpenIM.iMManager.userInfo.faceURL,
        showLeftNickname: !logic.isSingleChat,
        showRightNickname: false,
        onFailedToResend: () => logic.failedResend(message),
        onClickItemView: () => logic.parseClickEvent(message),
        onLongPressLeftAvatar: () {
          logic.onLongPressLeftAvatar(message);
        },
        onLongPressRightAvatar: () {},
        onTapLeftAvatar: () {
          logic.onTapLeftAvatar(message);
        },
        onTapRightAvatar: logic.onTapRightAvatar,
        onVisibleTrulyText: (text) {},
        customTypeBuilder: _buildCustomTypeItemView,
      );

  CustomTypeInfo? _buildCustomTypeItemView(_, Message message) {
    final data = IMUtils.parseCustomMessage(message);
    if (null != data) {
      final viewType = data['viewType'];
      if (viewType == CustomMessageType.call) {
        final type = data['type'];
        final content = data['content'];
        final view = ChatCallItemView(type: type, content: content);
        return CustomTypeInfo(view);
      } else if (viewType == CustomMessageType.deletedByFriend || viewType == CustomMessageType.blockedByFriend) {
        final view = ChatFriendRelationshipAbnormalHintView(
          name: logic.nickname.value,
          onTap: logic.sendFriendVerification,
          blockedByFriend: viewType == CustomMessageType.blockedByFriend,
          deletedByFriend: viewType == CustomMessageType.deletedByFriend,
        );
        return CustomTypeInfo(view, false, false);
      } else if (viewType == CustomMessageType.removedFromGroup) {
        return CustomTypeInfo(
          StrRes.removedFromGroupHint.toText..style = Styles.ts_8E9AB0_12sp,
          false,
          false,
        );
      } else if (viewType == CustomMessageType.groupDisbanded) {
        return CustomTypeInfo(
          StrRes.groupDisbanded.toText..style = Styles.ts_8E9AB0_12sp,
          false,
          false,
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.chat(
            title: logic.title,
            subTitle: logic.subTile,
            onCloseMultiModel: logic.exit,
            onClickMoreBtn: logic.chatSetup,
            onClickCallBtn: logic.call,
          ),
          body: WaterMarkBgView(
            text: logic.markText,
            backgroundColor: Styles.c_FFFFFF,
            bottomView: ChatInputBox(
              allAtMap: logic.atUserNameMappingMap,
              controller: logic.inputCtrl,
              focusNode: logic.focusNode,
              isNotInGroup: logic.isInvalidGroup,
              onSend: (v) => logic.sendTextMsg(),
              toolbox: ChatToolBox(
                onTapAlbum: logic.onTapAlbum,
                onTapCamera: logic.onTapCamera,
                onTapCall: logic.call,
              ),
            ),
            child: ChatListView(
              itemCount: logic.messageList.length,
              controller: logic.scrollController,
              onScrollToBottomLoad: logic.onScrollToBottomLoad,
              onScrollToTop: logic.onScrollToTop,
              itemBuilder: (_, index) {
                final message = logic.indexOfMessage(index);
                return _buildItemView(message);
              },
            ),
          ),
        ));
  }
}
