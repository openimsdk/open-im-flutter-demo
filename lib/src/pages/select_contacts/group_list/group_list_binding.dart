import 'package:get/get.dart';

import 'group_list_logic.dart';

class GroupListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupListLogic());
  }
}
