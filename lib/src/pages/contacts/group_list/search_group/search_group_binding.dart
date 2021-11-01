import 'package:get/get.dart';

import 'search_group_logic.dart';

class SearchGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchGroupLogic());
  }
}
