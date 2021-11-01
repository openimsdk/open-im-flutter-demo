import 'package:get/get.dart';

import 'send_friend_request_logic.dart';

class SendFriendRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendFriendRequestLogic());
  }
}
