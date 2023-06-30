import 'package:get/get.dart';

import 'group_list_logic.dart';

class SelectContactsFromGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsFromGroupLogic());
  }
}
