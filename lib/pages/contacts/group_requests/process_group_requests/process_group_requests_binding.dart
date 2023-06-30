import 'package:get/get.dart';

import 'process_group_requests_logic.dart';

class ProcessGroupRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProcessGroupRequestsLogic());
  }
}
