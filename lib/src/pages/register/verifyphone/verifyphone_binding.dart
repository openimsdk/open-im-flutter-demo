import 'package:get/get.dart';

import 'verifyphone_logic.dart';

class VerifyPhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyPhoneLogic());
  }
}
