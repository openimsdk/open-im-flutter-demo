import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/models/contacts_info.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/routes/app_navigator.dart';
import 'package:openim_enterprise_chat/src/widgets/im_widget.dart';

class CreateGroupInChatSetupLogic extends GetxController {
  var nameCtrl = TextEditingController();
  var memberList = <ContactsInfo>[].obs;
  var avatarUrl = ''.obs;

  @override
  void onInit() {
    var list = Get.arguments['members'];
    memberList.add(ContactsInfo.fromJson(OpenIM.iMManager.uInfo.toJson()));
    memberList.addAll(list);
    super.onInit();
  }

   completeCreation() async {
    if (nameCtrl.text.trim().isEmpty) {
      IMWidget.showToast(StrRes.createGroupNameHint);
      return;
    }
    var gid = await OpenIM.iMManager.groupManager.createGroup(
      groupName: nameCtrl.text,
      faceUrl: avatarUrl.value,
      list: memberList.map((e) => GroupMemberRole(uid: e.uid)).toList(),
    );
    print('create group : $gid');
    AppNavigator.startChat(
      type: 1,
      gid: gid,
      name: nameCtrl.text,
      icon: avatarUrl.value,
    );
    // Get.offNamedUntil(
    //   AppRoutes.CHAT,
    //   (route) => route.settings.name == AppRoutes.HOME,
    //   arguments: {
    //     "gid": gid,
    //     "name": nameCtrl.text,
    //     "icon": avatarUrl.value,
    //   },
    // );
  }

  void setAvatar() {
    IMWidget.openPhotoSheet(onData: (path, url) {
      if (url != null) avatarUrl.value = url;
    });
  }

  int length() {
    return (memberList.length + 2) > 6 ? 6 : (memberList.length + 2);
  }

  Widget itemBuilder({
    required int index,
    required Widget Function(ContactsInfo info) builder,
    required Widget Function() addButton,
    required Widget Function() delButton,
  }) {
    if (memberList.length > 4) {
      if (index < 4) {
        var info = memberList.elementAt(index);
        return builder(info);
      } else if (index == 4) {
        return addButton();
      } else {
        return delButton();
      }
    } else {
      if (index < memberList.length) {
        var info = memberList.elementAt(index);
        return builder(info);
      } else if (index == memberList.length) {
        return addButton();
      } else {
        return delButton();
      }
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }
}
