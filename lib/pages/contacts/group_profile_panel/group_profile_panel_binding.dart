import 'package:get/get.dart';

import 'group_profile_panel_logic.dart';

class GroupProfilePanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupProfilePanelLogic());
  }
}
