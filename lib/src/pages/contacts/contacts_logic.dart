import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/core/controller/im_controller.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/utils/data_persistence.dart';

class ContactsLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var friendApplicationList = <UserInfo>[];
  var applicationCount = 0.obs;
  var frequentContacts = <UserInfo>[].obs;

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
            uid: e.userID!,
            name: e.showName,
            icon: e.faceUrl,
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
        var u = frequentContacts.firstWhere((e) => e.uid == value.uid);
        u.name = value.name;
        u.icon = value.icon;
        u.comment = value.comment;
        u.mobile = value.mobile;
        u.flag = value.flag;
        frequentContacts.refresh();
      } catch (e) {}
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

  void getFrequentContacts() async {
    var uidList = DataPersistence.getFrequentContacts();
    if (uidList.isNotEmpty) {
      var list = await OpenIM.iMManager.getUsersInfo(uidList);
      frequentContacts.assignAll(list);
    }
  }

  void putFrequentContacts() {
    var uidList = frequentContacts.map((e) => e.uid);
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
    // TODO: implement onClose
    super.onClose();
  }
}
