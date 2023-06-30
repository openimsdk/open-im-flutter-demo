import 'package:get/get.dart';

import 'select_contacts_logic.dart';

class SelectContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsLogic());
  }
}
