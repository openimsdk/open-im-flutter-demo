import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class SearchGroupLogic extends GetxController {
  var focusNode = FocusNode();
  var searchCtrl = TextEditingController();
  var groupList = <GroupInfo>[];
  var resultList = <GroupInfo>[].obs;

  @override
  void onInit() {
    var list = Get.arguments;
    if (list is List<GroupInfo>) {
      groupList.addAll(list);
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
    print('length: ${groupList.length}');
    if (key.isNotEmpty) {
      groupList.forEach((element) {
        if (element.groupName!.toUpperCase().contains(key.toUpperCase())) {
          resultList.add(element);
        }
      });
    }
  }
}
