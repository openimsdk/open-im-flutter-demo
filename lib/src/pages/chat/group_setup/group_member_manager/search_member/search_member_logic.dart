import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/group_member_info.dart';

class SearchMemberLogic extends GetxController {
  var focusNode = FocusNode();
  var searchCtrl = TextEditingController();
  var memberList = <GroupMembersInfo>[];
  var resultList = <GroupMembersInfo>[].obs;

  @override
  void onInit() {
    var list = Get.arguments;
    if (list is List<GroupMembersInfo>) {
      memberList.addAll(list);
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
      memberList.forEach((element) {
        if (element.nickname!.toUpperCase().contains(key.toUpperCase())) {
          resultList.add(element);
        }
      });
    }
  }

  selected(GroupMembersInfo info) {
    Get.back(result: info);
  }
}
