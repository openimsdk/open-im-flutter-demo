import 'package:get/get.dart';

import 'search_logic.dart';

class AddFriendBySearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddFriendBySearchLogic());
  }
}
