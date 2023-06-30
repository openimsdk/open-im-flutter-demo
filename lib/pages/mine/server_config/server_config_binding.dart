import 'package:get/get.dart';

import 'server_config_logic.dart';

class ServerConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServerConfigLogic());
  }
}
