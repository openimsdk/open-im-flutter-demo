import 'package:get/get.dart';

import 'setuppwd_logic.dart';

class SetupPwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetupPwdLogic());
  }
}
