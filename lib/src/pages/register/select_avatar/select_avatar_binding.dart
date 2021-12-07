import 'package:get/get.dart';

import 'select_avatar_logic.dart';

class SelectAvatarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectAvatarLogic());
  }
}
