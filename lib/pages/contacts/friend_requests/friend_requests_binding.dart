import 'package:get/get.dart';

import 'friend_requests_logic.dart';

class FriendRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendRequestsLogic());
  }
}
