import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/models/contacts_info.dart';

class SearchFriendLogic extends GetxController {
  var focusNode = FocusNode();
  var searchCtrl = TextEditingController();
  var friendList = <ContactsInfo>[];
  var resultList = <ContactsInfo>[].obs;

  @override
  void onInit() {
    var list = Get.arguments;
    if (list is List<ContactsInfo>) {
      friendList.addAll(list);
    }
    searchCtrl.addListener(search);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    focusNode.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  search() {
    var key = searchCtrl.text.trim();
    resultList.clear();
    if (key.isNotEmpty) {
      friendList.forEach((element) {
        if (element.getShowName().toUpperCase().contains(key.toUpperCase())) {
          resultList.add(element);
        }
      });
    }
  }
}
