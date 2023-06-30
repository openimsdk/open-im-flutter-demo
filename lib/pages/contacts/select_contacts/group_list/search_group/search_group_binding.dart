import 'package:get/get.dart';

import 'search_group_logic.dart';

class SelectContactsFromSearchGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsFromSearchGroupLogic());
  }
}
