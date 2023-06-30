import 'package:get/get.dart';

import 'chat_setup_logic.dart';

class ChatSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatSetupLogic());
  }
}
