import 'package:get/get.dart';

import 'group_manage_logic.dart';

class GroupManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupManageLogic());
  }
}
