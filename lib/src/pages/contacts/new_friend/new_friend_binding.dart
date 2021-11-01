import 'package:get/get.dart';

import 'new_friend_logic.dart';

class NewFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewFriendLogic());
  }
}
