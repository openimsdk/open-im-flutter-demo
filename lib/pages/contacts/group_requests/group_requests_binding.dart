import 'package:get/get.dart';

import 'group_requests_logic.dart';

class GroupRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupRequestsLogic());
  }
}
