import 'package:get/get.dart';

import 'qrcode_logic.dart';

class GroupQrcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupQrcodeLogic());
  }
}
