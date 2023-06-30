import 'package:get/get.dart';

import 'friend_list_logic.dart';

class FriendListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendListLogic());
  }
}
