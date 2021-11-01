import 'package:get/get.dart';

import 'group_member_manager_logic.dart';

class GroupMemberManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupMemberManagerLogic());
  }
}
