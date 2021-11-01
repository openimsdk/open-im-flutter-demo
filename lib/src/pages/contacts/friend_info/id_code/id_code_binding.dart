import 'package:get/get.dart';

import 'id_code_logic.dart';

class FriendIdCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendIdCodeLogic());
  }
}
