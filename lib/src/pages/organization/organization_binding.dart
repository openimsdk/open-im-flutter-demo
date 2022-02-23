import 'package:get/get.dart';

import 'organization_logic.dart';

class OrganizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrganizationLogic());
  }
}
