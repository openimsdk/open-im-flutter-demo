import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../global_search/global_search_logic.dart';
import '../select_contacts_logic.dart';

class SelectContactsFromSearchLogic extends CommonSearchLogic {
  final selectContactsLogic = Get.find<SelectContactsLogic>();
  final resultList = <dynamic>{}.obs;

  bool get isSearchNotResult =>
      searchCtrl.text.trim().isNotEmpty && resultList.isEmpty;

  @override
  void clearList() {
    resultList.clear();
  }

  void search() async {
    final result = await LoadingView.singleton.wrap(
        asyncFunction: () => Future.wait([
              searchFriend(),
              if (!selectContactsLogic.hiddenGroup) searchGroup(),
            ]));
  }
}
