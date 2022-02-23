import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/models/contacts_info.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/custom_dialog.dart';

enum SelAction {
  FORWARD,
  CARTE,
  CRATE_GROUP,
  ADD_MEMBER,
  RECOMMEND,
}

class SelectContactsLogic extends GetxController {
  var index = 0.obs;
  var contactsList = <ContactsInfo>[].obs;
  var checkedList = <ContactsInfo>[].obs;
  var defaultCheckedUidList = <String>[];
  var action;
  List<String>? excludeUidList;

  @override
  void onInit() {
    action = Get.arguments['action'] as SelAction;
    excludeUidList = Get.arguments['excludeUidList'];
    var list = Get.arguments['defaultCheckedUidList'];
    if (list is List) {
      defaultCheckedUidList.addAll(list.map((e) => '$e'));
    }
    super.onInit();
  }

  bool isMultiModel() {
    return action == SelAction.CRATE_GROUP || action == SelAction.ADD_MEMBER;
  }

  void switchTab(i) {
    index.value = i;
  }

  void getFriends() {
    OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) {
          if (null != excludeUidList && excludeUidList!.isNotEmpty) {
            var l = <ContactsInfo>[];
            list.forEach((e) {
              var info = ContactsInfo.fromJson(e);
              if (!excludeUidList!.contains(info.userID)) {
                l.add(info);
              }
            });
            return l;
          }
          return list.map((e) => ContactsInfo.fromJson(e)).toList();
        })
        .then((list) => IMUtil.convertToAZList(list))
        .then((list) => contactsList.assignAll(list.cast<ContactsInfo>()));
  }

  void selectedContacts(ContactsInfo info) {
    if (isMultiModel()) {
      if (checkedList.contains(info)) {
        checkedList.remove(info);
      } else {
        checkedList.add(info);
      }
      // info.isChecked = !(info.isChecked ?? false);
      // contactsList.refresh();
      return;
    }
    var title;
    var content;
    var url;
    var type;
    switch (action) {
      case SelAction.FORWARD:
        title = StrRes.confirmSendTo;
        content = info.getShowName();
        url = info.faceURL;
        type = DialogType.FORWARD;
        break;
      case SelAction.CARTE:
        title = StrRes.confirmSendCarte;
        type = DialogType.BASE;
        break;
      case SelAction.RECOMMEND:
        title = StrRes.confirmRecommendFriend;
        type = DialogType.BASE;
        break;
      default:
        break;
    }
    Get.dialog(CustomDialog(
      title: title,
      content: content,
      url: url,
      type: type,
    )).then((confirm) {
      if (confirm == true) {
        Get.back(
          result: {
            "uId": info.userID,
            "uName": info.getShowName(),
            "uIcon": info.faceURL,
          },
        );
      }
    });
  }

  // void _search(String text) {
  //   if (ObjectUtil.isEmpty(text)) {
  //     _handleList(originList);
  //   } else {
  //     List<Languages> list = originList.where((v) {
  //       return v.name.toLowerCase().contains(text.toLowerCase());
  //     }).toList();
  //     _handleList(list);
  //   }
  // }

  void removeContacts(ContactsInfo info) {
    checkedList.remove(info);
  }

  void confirmSelected() {
    if (checkedList.isEmpty) return;
    // 创建群组
    if (action == SelAction.CRATE_GROUP) {
      checkedList.addAll(
        contactsList.where((e) => defaultCheckedUidList.contains(e.userID)),
      );
      AppNavigator.startCreateGroupInChatSetup(members: checkedList.value);
      // Get.offAndToNamed(
      //   AppRoutes.CREATE_GROUP_IN_CHAT_SETUP,
      //   arguments: {'members': checkedList.value},
      // );
    } else if (action == SelAction.ADD_MEMBER) {
      // 添加成员
      Get.back(result: checkedList.value);
    }
  }

  @override
  void onReady() {
    getFriends();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
