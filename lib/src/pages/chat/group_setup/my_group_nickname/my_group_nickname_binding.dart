import 'package:get/get.dart';

import 'my_group_nickname_logic.dart';

class MyGroupNicknameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyGroupNicknameLogic());
  }
}
