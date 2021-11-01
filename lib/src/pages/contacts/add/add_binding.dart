import 'package:get/get.dart';

import 'add_logic.dart';

class AddContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddContactsLogic());
  }
}
