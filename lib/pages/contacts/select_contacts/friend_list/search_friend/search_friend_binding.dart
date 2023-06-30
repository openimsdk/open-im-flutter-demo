import 'package:get/get.dart';

import 'search_friend_logic.dart';

class SelectContactsFromSearchFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsFromSearchFriendsLogic());
  }
}
