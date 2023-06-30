import 'package:get/get.dart';

import 'search_contacts_logic.dart';

class SelectContactsFromSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsFromSearchLogic());
  }
}
