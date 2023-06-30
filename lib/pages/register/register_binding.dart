import 'package:get/get.dart';

import 'register_logic.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterLogic());
  }
}
