import 'package:get/get.dart';

import 'name_setup_logic.dart';

class GroupNameSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupNameSetupLogic());
  }
}
