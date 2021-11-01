import 'package:get/get.dart';

import 'setup_name_logic.dart';

class SetupUserNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetupUserNameLogic());
  }
}
