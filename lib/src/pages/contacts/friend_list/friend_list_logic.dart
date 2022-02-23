import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/im_util.dart';

class MyFriendListLogic extends GetxController {
  var friendList = <ContactsInfo>[].obs;
  var imLoic = Get.find<IMController>();
  var onlineStatus = <String, String>{}.obs;
  var uidList = <String>[];
  String? _comment;

  void getFriendList() async {
    OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) => list.where((e) => e['blackInfo'] == null))
        .then((list) {
          queryOnlineStatus(
              list.map((e) => UserInfo.fromJson(e).userID).toList().cast());
          return list;
        })
        .then((list) => list.map((e) => ContactsInfo.fromJson(e)).toList())
        .then((list) => IMUtil.convertToAZList(list))
        .then((list) => friendList.assignAll(list.cast<ContactsInfo>()));
  }

  void viewFriendInfo(int index) async {
    var info = friendList.elementAt(index);
    _comment = info.remark;
    await AppNavigator.startFriendInfo(info: info);
    // await Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
    //
    if (_comment != info.remark) {
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
      friendList.removeWhere((e) => e.userID == user.userID);
    });
    imLoic.friendAddSubject.listen((user) {
      print('add user:   ${json.encode(user)}');
      // getFriendList();
      _addUser(user.toJson());
    });
    imLoic.friendInfoChangedSubject.listen((user) {
      print('update user info:   ${json.encode(user)}');
      // getFriendList();
      friendList.removeWhere((e) => e.userID == user.userID);

      print('=========toJson:${user.toJson()}=========');
      _addUser(user.toJson());
    });

    imLoic.onBlacklistAdd = (user) {
      friendList.removeWhere((e) => e.userID == user.userID);
    };
    imLoic.onBlacklistDeleted = (user) {
      _addUser(user.toJson());
    };
    super.onInit();
  }

  void _addUser(Map<String, dynamic> json) {
    var info = ContactsInfo.fromJson(json);

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

  void queryOnlineStatus(List<String> uidList) {
    Apis.queryOnlineStatus(
      uidList: uidList,
      onlineStatusDescCallback: (map) => onlineStatus.addAll(map),
    );
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
