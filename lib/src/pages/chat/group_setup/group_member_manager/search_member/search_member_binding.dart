import 'package:get/get.dart';

import 'search_member_logic.dart';

class SearchMemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchMemberLogic());
  }
}
