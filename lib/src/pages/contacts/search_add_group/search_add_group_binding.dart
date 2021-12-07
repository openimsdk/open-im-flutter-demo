import 'package:get/get.dart';

import 'search_add_group_logic.dart';

class SearchAddGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchAddGroupLogic());
  }
}
