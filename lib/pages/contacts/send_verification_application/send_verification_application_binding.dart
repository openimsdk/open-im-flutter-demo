import 'package:get/get.dart';

import 'send_verification_application_logic.dart';

class SendVerificationApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendVerificationApplicationLogic());
  }
}
