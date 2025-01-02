import 'package:get/get.dart';

import '../group_setup_logic.dart';
import 'group_member_list_logic.dart';

class GroupMemberListBinding extends Bindings {
  @override
  void dependencies() {
    GroupMemberOpType opType = Get.arguments['opType'];
    Get.lazyPut(() => GroupMemberListLogic(), tag: opType.name);
    Get.lazyPut(() => GroupSetupLogic());
  }
}
