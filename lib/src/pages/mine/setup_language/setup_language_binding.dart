import 'package:get/get.dart';

import 'setup_language_logic.dart';

class SetupLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetupLanguageLogic());
  }
}
