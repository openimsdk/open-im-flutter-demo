import 'package:get/get.dart';

import 'oa_notification_logic.dart';

class OANotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OANotificationLogic());
  }
}
