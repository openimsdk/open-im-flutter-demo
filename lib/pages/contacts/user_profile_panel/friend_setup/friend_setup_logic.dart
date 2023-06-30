import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../../routes/app_navigator.dart';
import '../../../conversation/conversation_logic.dart';
import '../user_profile _panel_logic.dart';

class FriendSetupLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  final userProfilesLogic =
      Get.find<UserProfilePanelLogic>(tag: GetTags.userProfile);
  late String userID;

  @override
  void onInit() {
    userID = Get.arguments['userID'];
    super.onInit();
  }

  void toggleBlacklist() {
    if (userProfilesLogic.userInfo.value.isBlacklist == true) {
      removeBlacklist();
    } else {
      addBlacklist();
    }
  }

  /// 加入黑名单
  void addBlacklist() async {
    var confirm =
        await Get.dialog(CustomDialog(title: StrRes.areYouSureAddBlacklist));
    if (confirm == true) {
      await OpenIM.iMManager.friendshipManager.addBlacklist(
        userID: userProfilesLogic.userInfo.value.userID!,
      );
      userProfilesLogic.userInfo.update((val) {
        val?.isBlacklist = true;
      });
    }
  }

  /// 从黑名单移除
  void removeBlacklist() async {
    await OpenIM.iMManager.friendshipManager.removeBlacklist(
      userID: userProfilesLogic.userInfo.value.userID!,
    );
    userProfilesLogic.userInfo.update((val) {
      val?.isBlacklist = false;
    });
  }

  /// 解除好友关系
  void deleteFromFriendList() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.areYouSureDelFriend,
      rightText: StrRes.delete,
    ));
    if (confirm) {
      await LoadingView.singleton.wrap(asyncFunction: () async {
        await OpenIM.iMManager.friendshipManager.deleteFriend(
          userID: userProfilesLogic.userInfo.value.userID!,
        );
        userProfilesLogic.userInfo.update((val) {
          val?.isFriendship = false;
        });
        // final conversationID = await OpenIM.iMManager.conversationManager
        //     .getConversationIDBySessionType(
        //   sourceID: userInfo.value.userID!,
        //   sessionType: ConversationType.single,
        // );
        final userIDList = [
          userProfilesLogic.userInfo.value.userID,
          OpenIM.iMManager.userID,
        ];
        userIDList.sort();
        final conversationID = 'si_${userIDList.join('_')}';
        // 删除会话
        await OpenIM.iMManager.conversationManager
            .deleteConversationAndDeleteAllMsg(conversationID: conversationID);
        // 删除会话列表数据
        conversationLogic.list
            .removeWhere((e) => e.conversationID == conversationID);
      });
      // 如果从聊天窗口查看用户资料
      if (userProfilesLogic.offAllWhenDelFriend == true) {
        AppNavigator.startBackMain();
      } else {
        Get.back();
      }
    }
  }

  void setFriendRemark() => AppNavigator.startSetFriendRemark();
}
