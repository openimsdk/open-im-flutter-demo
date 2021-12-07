import 'package:get/get.dart';

import 'handle_application_logic.dart';

class HandleGroupApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HandleGroupApplicationLogic());
  }
}
