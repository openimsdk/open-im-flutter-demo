import 'package:get/get.dart';

import 'apply_enter_group_logic.dart';

class ApplyEnterGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplyEnterGroupLogic());
  }
}
