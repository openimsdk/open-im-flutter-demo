import 'package:get/get.dart';

import 'edit_name_logic.dart';

class EditGroupNameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditGroupNameLogic());
  }
}
