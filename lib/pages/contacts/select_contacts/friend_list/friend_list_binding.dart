import 'package:get/get.dart';

import 'friend_list_logic.dart';

class SelectContactsFromFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsFromFriendsLogic());
  }
}
