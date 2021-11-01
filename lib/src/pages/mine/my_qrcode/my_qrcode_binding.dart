import 'package:get/get.dart';

import 'my_qrcode_logic.dart';

class MyQrcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyQrcodeLogic());
  }
}
