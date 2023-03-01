import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/chat_listview.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'chat_logic.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>();

  Widget _itemView(index) => ChatItemView(
        key: logic.itemKey(index),
        index: index,
        message: logic.indexOfMessage(index),
        timeStr: logic.getShowTime(index),
        isSingleChat: logic.isSingleChat,
        clickSubject: logic.clickSubject,
        msgSendStatusSubject: logic.msgSendStatusSubject,
        msgSendProgressSubject: logic.msgSendProgressSubject,
        multiSelMode: logic.multiSelMode.value,
        multiList: logic.multiSelList.value,
        allAtMap: logic.atUserNameMappingMap,
        delaySendingStatus: true,
        onMultiSelChanged: (checked) {
          logic.multiSelMsg(index, checked);
        },
        onTapCopyMenu: () {
          logic.copy(index);
        },
        onTapDelMenu: () {
          logic.deleteMsg(index);
        },
        onTapForwardMenu: () {
          logic.forward(index);
        },
        onTapReplyMenu: () {
          logic.setQuoteMsg(index);
        },
        onTapRevokeMenu: () {
          logic.revokeMsg(index);
        },
        onTapMultiMenu: () {
          logic.openMultiSelMode(index);
        },
        visibilityChange: (context, index, message, visible) {
          print('visible:$index $visible');
          logic.markC2CMessageAsRead(index, message, visible);
        },
        onLongPressLeftAvatar: () {
          logic.onLongPressLeftAvatar(index);
        },
        onLongPressRightAvatar: () {},
        onTapLeftAvatar: () {
          logic.onTapLeftAvatar(index);
        },
        onTapRightAvatar: () {},
        onClickAtText: (uid) {
          logic.clickAtText(uid);
        },
        onTapQuoteMsg: () {
          logic.onTapQuoteMsg(index);
        },
        patterns: <MatchPattern>[
          MatchPattern(
            type: PatternType.AT,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.EMAIL,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.URL,
            style: PageStyle.ts_1B72EC_14sp_underline,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.MOBILE,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.TEL,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
        ],
        customItemBuilder: _buildCustomItemView,
        enabledReadStatus: logic.enabledReadStatus(index),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: logic.multiSelMode.value ? () async => logic.exit() : null,
          child: ChatVoiceRecordLayout(
            locale: Get.locale,
            builder: (bar) => Obx(() => Scaffold(
                  backgroundColor: PageStyle.c_FFFFFF,
                  appBar: EnterpriseTitleBar.chatTitle(
                    title: logic.name.value,
                    subTitle: logic.getSubTile(),
                    onClickCallBtn: () => logic.call(),
                    onClickMoreBtn: () => logic.chatSetup(),
                    leftButton: logic.multiSelMode.value ? StrRes.cancel : null,
                    onClose: () => logic.exit(),
                    showOnlineStatus: logic.showOnlineStatus(),
                    online: logic.onlineStatus.value,
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ChatListView(
                            listViewKey: ObjectKey(logic.listViewKey.value),
                            onTouch: () => logic.closeToolbox(),
                            itemCount: logic.messageList.length,
                            controller: logic.autoCtrl,
                            onLoad: () => logic.getHistoryMsgList(),
                            itemBuilder: (_, index) => Obx(() => _itemView(index)),
                          ),
                        ),
                        ChatInputBoxView(
                          controller: logic.inputCtrl,
                          allAtMap: logic.atUserNameMappingMap,
                          enabledEmojiButton: !logic.isRobot(),
                          enabledToolboxButton: !logic.isRobot(),
                          enabledVoiceButton: !logic.isRobot(),
                          toolbox: ChatToolsView(
                            onTapAlbum: () => logic.onTapAlbum(),
                            onTapCamera: () => logic.onTapCamera(),
                            onTapCarte: () => logic.onTapCarte(),
                            onTapFile: () => logic.onTapFile(),
                            onTapLocation: () => logic.onTapLocation(),
                            onTapVideoCall: () => logic.call(),
                            onStopVoiceInput: () => logic.onStopVoiceInput(),
                            onStartVoiceInput: () => logic.onStartVoiceInput(),
                          ),
                          multiOpToolbox: ChatMultiSelToolbox(
                            onDelete: () => logic.mergeDelete(),
                            onMergeForward: () => logic.mergeForward(),
                          ),
                          emojiView: ChatEmojiView(
                            onAddEmoji: logic.onAddEmoji,
                            onDeleteEmoji: logic.onDeleteEmoji,
                            textEditingController: logic.inputCtrl,
                          ),
                          onSubmitted: (v) => logic.sendTextMsg(),
                          forceCloseToolboxSub: logic.forceCloseToolbox,
                          voiceRecordBar: bar,
                          quoteContent: logic.quoteContent.value,
                          onClearQuote: () => logic.setQuoteMsg(-1),
                          multiMode: logic.multiSelMode.value,
                          focusNode: logic.focusNode,
                          inputFormatters: [AtTextInputFormatter(logic.openAtList)],
                        ),
                      ],
                    ),
                  ),
                )),
            onCompleted: (sec, path) {
              logic.sendVoice(duration: sec, path: path);
            },
          ),
        ));
  }

  /// custom item view
  Widget? _buildCustomItemView(
    BuildContext context,
    int index,
    Message message,
  ) {
    var data = logic.parseCustomMessage(index);
    if (null != data && data['viewType'] == CustomMessageViewType.call) {
      return _buildCallItemView(type: data['type'], content: data['content']);
    }
    return null;
  }

  /// 通话item
  Widget _buildCallItemView({
    required String type,
    required String content,
  }) =>
      Row(
        children: [
          Image.asset(
            type == 'voice' ? ImageRes.ic_voiceCallMsg : ImageRes.ic_videoCallMsg,
            width: 20.h,
            height: 20.h,
          ),
          SizedBox(width: 6.w),
          Text(
            content,
            style: PageStyle.ts_333333_14sp,
          ),
        ],
      );

  /// 群公告item
  Widget _buildAnnouncementItemView(String content) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(ImageRes.ic_trumpet, width: 16.h, height: 16.h),
                SizedBox(width: 4.w),
                Text(
                  StrRes.groupAnnouncement,
                  style: PageStyle.ts_898989_13sp,
                )
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              content,
              style: PageStyle.ts_333333_13sp,
            ),
          ],
        ),
      );
}
