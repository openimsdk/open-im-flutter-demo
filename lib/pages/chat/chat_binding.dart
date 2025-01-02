import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'chat_logic.dart';
import 'group_setup/group_setup_logic.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatLogic(), tag: GetTags.chat);
    Get.lazyPut(() => GroupSetupLogic());
  }
}
