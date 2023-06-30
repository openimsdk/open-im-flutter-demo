import 'package:get/get.dart';

import 'mine_logic.dart';

class MineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineLogic());
  }
}
