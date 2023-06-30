import 'package:get/get.dart';

import 'group_qrcode_logic.dart';

class GroupQrcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupQrcodeLogic());
  }
}
