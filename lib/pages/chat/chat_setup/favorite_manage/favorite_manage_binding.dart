import 'package:get/get.dart';

import 'favorite_manage_logic.dart';

class FavoriteManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteManageLogic());
  }
}
