import 'package:get/get.dart';

import 'discover_logic.dart';

class DiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverLogic());
  }
}
