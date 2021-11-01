import 'package:get/get.dart';

import 'remark_logic.dart';

class FriendRemarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendRemarkLogic());
  }
}
