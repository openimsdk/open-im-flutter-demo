import 'package:get/get.dart';

import 'language_setup_logic.dart';

class LanguageSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageSetupLogic());
  }
}
