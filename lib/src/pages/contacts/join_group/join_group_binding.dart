import 'package:get/get.dart';

import 'jion_group_logic.dart';

class JoinGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoinGroupLogic());
  }
}
