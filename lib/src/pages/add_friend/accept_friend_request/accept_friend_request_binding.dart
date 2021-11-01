import 'package:get/get.dart';

import 'accept_friend_request_logic.dart';

class AcceptFriendRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AcceptFriendRequestLogic());
  }
}
