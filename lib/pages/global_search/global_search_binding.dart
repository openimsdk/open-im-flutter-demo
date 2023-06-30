import 'package:get/get.dart';

import 'global_search_logic.dart';

class GlobalSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GlobalSearchLogic());
  }
}
