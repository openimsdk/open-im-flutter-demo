import 'package:get/get.dart';

import 'friend_info_logic.dart';

class FriendInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendInfoLogic());
  }
}
