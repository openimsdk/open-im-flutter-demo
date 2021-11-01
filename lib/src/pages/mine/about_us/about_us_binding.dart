import 'package:get/get.dart';

import 'about_us_logic.dart';

class AboutUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AboutUsLogic());
  }
}
