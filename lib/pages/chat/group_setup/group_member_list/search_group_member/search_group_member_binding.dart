import 'package:get/get.dart';

import 'search_group_member_logic.dart';

class SearchGroupMemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchGroupMemberLogic());
  }
}
