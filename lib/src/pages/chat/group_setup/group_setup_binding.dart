import 'package:get/get.dart';

import 'group_setup_logic.dart';

class GroupSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupSetupLogic());
  }
}
