import 'package:get/get.dart';

import 'member_list_logic.dart';

class GroupMemberListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupMemberListLogic());
  }
}
