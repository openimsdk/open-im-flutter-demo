import 'package:get/get.dart';

import 'set_password_logic.dart';

class SetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetPasswordLogic());
  }
}
