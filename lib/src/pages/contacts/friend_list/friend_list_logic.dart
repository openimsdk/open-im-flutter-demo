import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/res/strings.dart';
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
        // .then((list) => list.where((e) => e['isInBlackList'] != 1))
        .then((list) => list.where((e) => _filterBlackList(e)))
        .then((list) {
          queryOnlineStatus(uidList);
          return list;
        })
        .then((list) => list.map((e) => ContactsInfo.fromJson(e)).toList())
        .then((list) => IMUtil.convertToAZList(list))
        .then((list) => friendList.assignAll(list.cast<ContactsInfo>()));
  }

  bool _filterBlackList(Map<String, dynamic> map) {
    uidList.add(map['uid']!);
    return map["isInBlackList"] != 1;
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

  void queryOnlineStatus(List<String> uidList) {
    Apis.onlineStatus(uidList: uidList).then((list) {
      list.forEach((e) {
        if (e.status == 'online') {
          // IOSPlatformStr     = "IOS"
          // AndroidPlatformStr = "Android"
          // WindowsPlatformStr = "Windows"
          // OSXPlatformStr     = "OSX"
          // WebPlatformStr     = "Web"
          // MiniWebPlatformStr = "MiniWeb"
          // LinuxPlatformStr   = "Linux"
          for (var platform in e.detailPlatformStatus!) {
            if (platform.platform == "Android" || platform.platform == "IOS") {
              onlineStatus[e.userID!] = StrRes.phoneOnline;
            } else if (platform.platform == "Windows") {
              onlineStatus[e.userID!] = StrRes.pcOnline;
            } else if (platform.platform == "Web" ||
                platform.platform == "MiniWeb") {
              onlineStatus[e.userID!] = StrRes.webOnline;
            } else {
              onlineStatus[e.userID!] = StrRes.online;
            }
          }
        } else {
          onlineStatus[e.userID!] = StrRes.offline;
        }
      });
      // onlineStatus.refresh();
    });
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
