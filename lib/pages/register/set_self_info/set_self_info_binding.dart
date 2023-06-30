import 'package:get/get.dart';

import 'set_self_info_logic.dart';

class SetSelfInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetSelfInfoLogic());
  }
}
