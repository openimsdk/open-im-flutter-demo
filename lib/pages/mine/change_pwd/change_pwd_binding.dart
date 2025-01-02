import 'package:get/get.dart';

import 'change_pwd_logic.dart';

class ChangePwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePwdLogic());
  }
}
