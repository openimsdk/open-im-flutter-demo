import 'package:get/get.dart';

import 'group_member_list_logic.dart';

class GroupMemberListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupMemberListLogic());
  }
}
