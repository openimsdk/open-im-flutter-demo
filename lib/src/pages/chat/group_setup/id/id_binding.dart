import 'package:get/get.dart';

import 'id_logic.dart';

class GroupIDBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupIDLogic());
  }
}
