import 'package:get/get.dart';

import 'account_setup_logic.dart';

class AccountSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountSetupLogic());
  }
}
