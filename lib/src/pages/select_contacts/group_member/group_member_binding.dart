import 'package:get/get.dart';

import 'group_member_logic.dart';

class SelectByGroupMemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectByGroupMemberLogic());
  }
}
