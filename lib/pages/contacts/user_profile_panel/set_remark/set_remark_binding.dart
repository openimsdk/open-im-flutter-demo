import 'package:get/get.dart';

import 'set_remark_logic.dart';

class SetFriendRemarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetFriendRemarkLogic());
  }
}
