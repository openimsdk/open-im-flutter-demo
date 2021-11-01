import 'package:get/get.dart';

import 'friend_list_logic.dart';

class MyFriendListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyFriendListLogic());
  }
}
