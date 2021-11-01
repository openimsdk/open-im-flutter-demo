import 'package:get/get.dart';

import 'create_group_logic.dart';

class CreateGroupInChatSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateGroupInChatSetupLogic());
  }
}
