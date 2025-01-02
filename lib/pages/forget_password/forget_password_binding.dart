import 'package:get/get.dart';

import 'forget_password_logic.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPasswordLogic());
  }
}
