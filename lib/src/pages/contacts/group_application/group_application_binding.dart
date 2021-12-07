import 'package:get/get.dart';

import 'group_application_logic.dart';

class GroupApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupApplicationLogic());
  }
}
