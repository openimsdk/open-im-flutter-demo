import 'package:get/get.dart';

import 'mini_program_logic.dart';

class MiniProgramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MiniProgramLogic());
  }
}
