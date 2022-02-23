import 'package:get/get.dart';

import 'workbench_logic.dart';

class WorkbenchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkbenchLogic());
  }
}
