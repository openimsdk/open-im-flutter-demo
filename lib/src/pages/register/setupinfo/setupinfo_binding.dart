import 'package:get/get.dart';

import 'setupinfo_logic.dart';

class SetupSelfInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetupSelfInfoLogic());
  }
}
