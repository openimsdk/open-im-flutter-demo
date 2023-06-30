import 'package:get/get.dart';

import 'conversation_logic.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConversationLogic());
  }
}
