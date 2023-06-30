import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../user_profile _panel_logic.dart';

class SetFriendRemarkLogic extends GetxController {
  final userProfilesLogic =
      Get.find<UserProfilePanelLogic>(tag: GetTags.userProfile);
  late TextEditingController inputCtrl;

  void save() async {
    try {
      await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.friendshipManager.setFriendRemark(
          userID: userProfilesLogic.userInfo.value.userID!,
          remark: inputCtrl.text.trim(),
        ),
      );
      IMViews.showToast(StrRes.saveSuccessfully);
      Get.back(result: inputCtrl.text.trim());
    } catch (_) {
      IMViews.showToast(StrRes.saveFailed);
    }
  }

  @override
  void onInit() {
    inputCtrl =
        TextEditingController(text: userProfilesLogic.userInfo.value.remark);
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }
}
