import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';

class ChatSetupLogic extends GetxController {
  var topContacts = false.obs;
  var noDisturb = false.obs;
  String? uid;
  String? name;
  String? icon;

  void toggleTopContacts() {
    topContacts.value = !topContacts.value;
  }

  void toggleNoDisturb() {
    noDisturb.value = !noDisturb.value;
  }

  void clearChatHistory() {
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

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
