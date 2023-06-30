import 'package:get/get.dart';

import 'my_info_logic.dart';

class MyInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyInfoLogic());
  }
}
