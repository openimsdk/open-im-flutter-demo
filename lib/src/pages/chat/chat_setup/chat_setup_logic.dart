import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/chat/chat_logic.dart';
import 'package:openim_demo/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class ChatSetupLogic extends GetxController {
  var topContacts = false.obs;
  var noDisturb = false.obs;
  var blockFriends = false.obs;
  var chatLogic = Get.find<ChatLogic>();
  String? uid;
  String? name;
  String? icon;
  ConversationInfo? info;
  var messageSet = 0.obs;

  void toggleTopContacts() async {
    topContacts.value = !topContacts.value;
    if (info == null) return;
    await OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info!.conversationID,
      isPinned: topContacts.value,
    );
  }

  void toggleNoDisturb() {
    noDisturb.value = !noDisturb.value;
  }

  void toggleBlockFriends() {
    blockFriends.value = !blockFriends.value;
  }

  void clearChatHistory() async {
    await OpenIM.iMManager.messageManager.clearC2CHistoryMessage(uid: uid!);
    chatLogic.clearAllMessage();
    IMWidget.showToast(StrRes.clearSuccess);
    // OpenIM.iMManager.messageManager.deleteMessageFromLocalStorage(message: message)
  }

  void toSelectGroupMember() {
    AppNavigator.startSelectContacts(
      action: SelAction.CRATE_GROUP,
      defaultCheckedUidList: [uid!],
    );
    // Get.toNamed(
    //   AppRoutes.SELECT_CONTACTS,
    //   arguments: {
    //     'action': SelAction.CRATE_GROUP,
    //     'uidList': [uid]
    //   },
    // );
  }

  @override
  void onInit() {
    uid = Get.arguments['uid'];
    name = Get.arguments['name'];
    icon = Get.arguments['icon'];
    super.onInit();
  }

  void getConversationInfo() async {
    info = await OpenIM.iMManager.conversationManager.getSingleConversation(
      sourceID: uid!,
      sessionType: 1,
    );
    topContacts.value = info!.isPinned == 1;
  }

  @override
  void onReady() {
    getConversationInfo();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void messageSetting() {
    IMWidget.openMessageSettingSheet(
      isGroup: false,
      onTap: (index) {
        messageSet.value = index;
      },
    );
  }
}
