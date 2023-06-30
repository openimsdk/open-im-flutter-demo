import 'package:get/get.dart';

import 'verify_phone_logic.dart';

class VerifyPhoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyPhoneLogic());
  }
}
