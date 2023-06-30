import 'package:get/get.dart';

import 'add_method_logic.dart';

class AddContactsMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddContactsMethodLogic());
  }
}
