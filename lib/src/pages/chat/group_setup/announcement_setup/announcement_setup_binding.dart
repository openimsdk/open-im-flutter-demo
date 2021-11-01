import 'package:get/get.dart';

import 'announcement_setup_logic.dart';

class GroupAnnouncementSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupAnnouncementSetupLogic());
  }
}
