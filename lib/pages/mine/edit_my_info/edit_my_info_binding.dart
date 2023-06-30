import 'package:get/get.dart';

import 'edit_my_info_logic.dart';

class EditMyInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditMyInfoLogic());
  }
}
