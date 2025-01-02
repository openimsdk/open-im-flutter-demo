import 'package:get/get.dart';

import 'unlock_setup_logic.dart';

class UnlockSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UnlockSetupLogic());
  }
}
