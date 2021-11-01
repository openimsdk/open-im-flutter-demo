import 'package:get/get.dart';

import 'add_my_method_logic.dart';

class AddMyMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddMyMethodLogic());
  }
}
