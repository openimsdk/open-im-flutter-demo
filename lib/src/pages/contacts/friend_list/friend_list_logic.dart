import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/models/contacts_info.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/im_util.dart';

class MyFriendListLogic extends GetxController {
  var friendList = <ContactsInfo>[].obs;
  var imLoic = Get.find<IMController>();
  String? _comment;

  void getFriendList() async {
    OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) => list.where((e) => e['isInBlackList'] != 1))
        .then((list) => list.map((e) => ContactsInfo.fromJson(e)).toList())
        .then((list) => IMUtil.convertToAZList(list))
        .then((list) => friendList.assignAll(list.cast<ContactsInfo>()));
  }

  void viewFriendInfo(int index) async {
    var info = friendList.elementAt(index);
    _comment = info.comment;
    await AppNavigator.startFriendInfo(info: info);
    // await Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
    //
    if (_comment != info.comment) {
      IMUtil.setAzPinyinAndTag(info);

      // A-Z sort.
      SuspensionUtil.sortListBySuspensionTag(friendList);

      // show sus tag.
      SuspensionUtil.setShowSuspensionStatus(friendList);
    }
  }

  @override
  void onInit() {
    imLoic.friendDelSubject.listen((user) {
      print('delete user:   ${json.encode(user)}');
      friendList.removeWhere((e) => e.uid == user.uid);
    });
    imLoic.friendAddSubject.listen((user) {
      print('add user:   ${json.encode(user)}');
      // getFriendList();
      _addUser(user);
    });
    imLoic.friendInfoChangedSubject.listen((user) {
      print('update user info:   ${json.encode(user)}');
      // getFriendList();
      friendList.removeWhere((e) => e.uid == user.uid);

      _addUser(user);
    });

    imLoic.onBlackListAdd = (user) {
      friendList.removeWhere((e) => e.uid == user.uid);
    };
    imLoic.onBlackListDeleted = (user) {
      _addUser(user);
    };
    super.onInit();
  }

  void _addUser(UserInfo user) {
    var info = ContactsInfo.fromJson(user.toJson());

    //
    friendList.add(IMUtil.setAzPinyinAndTag(info) as ContactsInfo);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(friendList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(friendList);
    // IMUtil.convertToAZList(friendList);

    // friendList.refresh();
  }

  void searchFriend() {
    AppNavigator.startSearchFriend(list: friendList.value);
    // Get.toNamed(AppRoutes.SEARCH_FRIEND, arguments: friendList.value);
  }

  @override
  void onReady() {
    getFriendList();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
