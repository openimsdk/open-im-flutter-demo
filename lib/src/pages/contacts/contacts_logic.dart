import 'dart:async';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';

class ContactsLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var friendApplicationList = <UserInfo>[];
  var friendApplicationCount = 0.obs;
  var groupApplicationCount = 0.obs;
  var frequentContacts = <UserInfo>[].obs;
  var onlineStatusDesc = <String, String>{}.obs;
  Timer? _onlineStatusTimer;

  @override
  void onInit() {
    // imLogic.friendApplicationSubject.listen((value) {
    //
    // });
    // 收到新的好友申请
    // imLogic.onFriendApplicationListAdded = (u) {
    //   getFriendApplicationList();
    // };
    // 删除好友申请记录
    // imLogic.onFriendApplicationListDeleted = (u) {
    //   getFriendApplicationList();
    // };
    /// 我的申请被拒绝了
    // imLogic.onFriendApplicationListRejected = (u) {
    //   getFriendApplicationList();
    // };
    // 我的申请被接受了
    // imLogic.onFriendApplicationListAccepted = (u) {
    //   getFriendApplicationList();
    // };

    imLogic.conversationChangedSubject.listen((list) {
      var uList = <UserInfo>[];
      list.forEach((e) {
        if (e.isSingleChat) {
          var u = UserInfo(
            userID: e.userID!,
            nickname: e.showName,
            faceURL: e.faceURL,
          );
          uList.add(u);
        }
      });
      if (uList.isNotEmpty) {
        // if (uList.length > 15) {
        //   frequentContacts.assignAll(uList.take(15));
        // } else {
        //   frequentContacts.assignAll(uList);
        // }
        frequentContacts.assignAll(uList);
        // frequentContacts.insertAll(0, uList);
        // frequentContacts.refresh();
        putFrequentContacts();
      }
    });

    imLogic.friendInfoChangedSubject.listen((value) {
      try {
        var u = frequentContacts.firstWhere((e) => e.userID == value.userID);
        u.nickname = value.nickname;
        u.faceURL = value.faceURL;
        u.remark = value.remark;
        u.phoneNumber = value.phoneNumber;
        frequentContacts.refresh();
      } catch (e) {}
    });

    imLogic.friendDelSubject.listen((user) {
      frequentContacts.removeWhere((e) => e.userID == user.userID);
      putFrequentContacts();
    });
    super.onInit();
  }

  /// 获取好友申请列表
  // void getFriendApplicationList() async {
  //   var list =
  //       await OpenIM.iMManager.friendshipManager.getFriendApplicationList();
  //   friendApplicationList.assignAll(list);
  //   _calNewApplicationCount();
  // }

  /// 获取好友申请未处理数
  // void _calNewApplicationCount() {
  //   applicationCount.value = 0;
  //   for (var info in friendApplicationList) {
  //     if (info.flag == 0) applicationCount.value++;
  //   }
  // }

  void toAddFriend() {
    AppNavigator.startAddContacts();
    // Get.toNamed(AppRoutes.ADD_CONTACTS);
  }

  void toFriendApplicationList() {
    AppNavigator.startFriendApplicationList();
    // Get.toNamed(AppRoutes.NEW_FRIEND_APPLICATION);
  }

  void toMyFriendList() {
    AppNavigator.startFriendList();
    // Get.toNamed(AppRoutes.FRIEND_LIST);
  }

  void toMyGroupList() {
    AppNavigator.startGroupList();
    // Get.toNamed(AppRoutes.GROUP_LIST);
  }

  void viewGroupApplication() {
    AppNavigator.startGroupApplication();
  }

  void getFrequentContacts() async {
    var uidList = DataPersistence.getFrequentContacts();
    if (uidList != null && uidList.isNotEmpty) {
      var list = await OpenIM.iMManager.friendshipManager.getFriendsInfo(
        uidList: uidList,
      );
      frequentContacts.assignAll(list);
      _checkOnlineStatus();
      _startOnlineStatusTimer();
    }
  }

  void putFrequentContacts() {
    var uidList = frequentContacts.map((e) => e.userID!);
    if (uidList.length > 15) {
      DataPersistence.putFrequentContacts(uidList.take(15).toList());
    } else {
      DataPersistence.putFrequentContacts(uidList.toList());
    }
    // DataPersistence.putFrequentContacts(uidList.toList());
  }

  void viewContactsInfo(info) {
    AppNavigator.startFriendInfo(info: info);
    // Get.toNamed(AppRoutes.FRIEND_INFO, arguments: info);
  }

  bool removeFrequentContacts(UserInfo info) {
    bool suc = frequentContacts.remove(info);
    putFrequentContacts();
    return suc;
  }

  @override
  void onReady() {
    getFrequentContacts();
    super.onReady();
  }

  @override
  void onClose() {
    _onlineStatusTimer?.cancel();
    super.onClose();
  }

  void viewOrganization() {
    AppNavigator.startOrganization();
  }

  void _startOnlineStatusTimer() {
    _onlineStatusTimer?.cancel();
    _onlineStatusTimer = null;
    _onlineStatusTimer = Timer.periodic(
      Duration(seconds: 10),
      (timer) => _checkOnlineStatus(),
    );
  }

  void _checkOnlineStatus() => Apis.queryOnlineStatus(
        uidList: frequentContacts.map((e) => e.userID!).toList(),
        onlineStatusDescCallback: (map) => onlineStatusDesc.addAll(map),
      );
}
