import 'package:get/get.dart';

import 'my_id_logic.dart';

class MyIDBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyIDLogic());
  }
}
