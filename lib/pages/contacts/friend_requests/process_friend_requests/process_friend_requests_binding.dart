import 'package:get/get.dart';

import 'process_friend_requests_logic.dart';

class ProcessFriendRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProcessFriendRequestsLogic());
  }
}
