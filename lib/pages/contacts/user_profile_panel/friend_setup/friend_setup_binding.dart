import 'package:get/get.dart';

import 'friend_setup_logic.dart';

class FriendSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendSetupLogic());
  }
}
