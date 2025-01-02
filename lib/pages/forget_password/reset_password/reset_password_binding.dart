import 'package:get/get.dart';

import 'reset_password_logic.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordLogic());
  }
}
