import 'package:get/get.dart';

import 'personal_info_logic.dart';

class PersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalInfoLogic());
  }
}
