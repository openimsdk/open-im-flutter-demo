import 'package:get/get.dart';

import 'blacklist_logic.dart';

class BlacklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BlacklistLogic());
  }
}
