import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';
import 'package:openim_enterprise_chat/src/widgets/touch_close_keyboard.dart';

import 'chat_logic.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>();

  Widget _itemView(index) => ChatItemView(
        key: logic.itemKey(index),
        index: index,
//         localizations: local,
        message: logic.indexOfMessage(index),
        timeStr: logic.getShowTime(index),
        isSingleChat: logic.isSingleChat,
        clickSubject: logic.clickSubject,
        msgSendStatusSubject: logic.msgSendStatusSubject,
        msgSendProgressSubject: logic.msgSendProgressSubject,
        multiSelMode: logic.multiSelMode.value,
        multiList: logic.multiSelList.value,
        allAtMap: logic.atUserNameMappingMap,
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
        onClickUrlText: (url) {
          logic.clickUrlText(url);
        },
        onTapQuoteMsg: () {
          logic.onTapQuoteMsg(index);
        },
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return logic.exit();
      },
      child: ChatVoiceRecordLayout(
        builder: (bar) => Obx(() => Scaffold(
              backgroundColor: PageStyle.c_FFFFFF,
              appBar: EnterpriseTitleBar.chatTitle(
                title: logic.name.value,
                subTitle: logic.typing.value ? '正在输入...' : 'xxx技术有限公司',
                onClickCallBtn: () => logic.call(),
                onClickMoreBtn: () => logic.chatSetup(),
                leftButton: logic.multiSelMode.value ? StrRes.cancel : null,
                onClose: () => logic.exit(),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: TouchCloseSoftKeyboard(
                        onTouch: () => logic.closeToolbox(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                            key: ObjectKey(logic.listViewKey.value),
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: logic.messageList.length,
                            // padding: EdgeInsets.only(top: 10.h),
                            controller: logic.autoCtrl,
                            itemBuilder: (_, index) =>
                                Obx(() => _itemView(index)),
                          ),
                        ),
                        // child: ListView.builder(
                        //   itemCount: logic.messageList.length,
                        //   padding: EdgeInsets.only(top: 10.h),
                        //   controller: logic.autoCtrl,
                        //   itemBuilder: (_, index) => Obx(() => AutoScrollTag(
                        //         key: ValueKey(index),
                        //         controller: logic.autoCtrl,
                        //         index: index,
                        //         child: _itemView(index, local),
                        //       )),
                        // ),
                      ),
                    ),
                    ChatInputBoxView(
                      controller: logic.inputCtrl,
                      allAtMap: logic.atUserNameMappingMap,
                      toolbox: ChatToolsView(
                        localizations: local,
                        onTapAlbum: () => logic.onTapAlbum(),
                        onTapCamera: () => logic.onTapCamera(),
                        onTapCarte: () => logic.onTapCarte(),
                        onTapFile: () => logic.onTapFile(),
                        onTapLocation: () => logic.onTapLocation(),
                        onTapVideoCall: () => logic.call(),
                        onTapVoiceInput: () {},
                      ),
                      multiOpToolbox: ChatMultiSelToolbox(
                        onDelete: () => logic.mergeDelete(),
                        onMergeForward: () => logic.mergeForward(),
                      ),
                      onSubmitted: (v) => logic.sendTextMsg(),
                      forceCloseToolboxSub: logic.forceCloseToolbox,
                      voiceRecordBar: bar,
                      quoteContent: logic.quoteContent.value,
                      onClearQuote: () => logic.setQuoteMsg(-1),
                      multiMode: logic.multiSelMode.value,
                      focusNode: logic.focusNode,
                    ),
                  ],
                ),
              ),
            )),
        onCompleted: (sec, path) {
          logic.sendVoice(duration: sec, path: path);
        },
      ),
    );
  }
}
