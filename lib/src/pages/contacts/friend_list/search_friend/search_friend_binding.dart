import 'package:get/get.dart';

import 'search_friend_logic.dart';

class SearchFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchFriendLogic());
  }
}
