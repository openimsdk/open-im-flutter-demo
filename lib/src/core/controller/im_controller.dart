import 'dart:io';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/config.dart';
import 'package:openim_demo/src/core/callback/im_callback.dart';
import 'package:path_provider/path_provider.dart';

class IMController extends GetxController with IMCallback {
  late Rx<UserInfo> userInfo;

  @override
  void onClose() {
    super.close();
    // OpenIM.iMManager.unInitSDK();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    // Initialize SDK
    await OpenIM.iMManager.initSDK(
      platform: Platform.isAndroid ? IMPlatform.android : IMPlatform.ios,
      apiAddr: Config.imApiUrl(),
      wsAddr: Config.imWsUrl(),
      dataDir: '${(await getApplicationDocumentsDirectory()).path}/',
      objectStorage: Config.objectStorage(),
      listener: OnConnectListener(
        onConnecting: () {},
        onConnectFailed: (code, error) {},
        onConnectSuccess: () {},
        onKickedOffline: kickedOffline,
        onUserTokenExpired: () {},
      ),
    );
    // Set listener
    OpenIM.iMManager
      //
      ..userManager.setUserListener(OnUserListener(
        onSelfInfoUpdated: (u) {
          userInfo.value = u;
        },
      ))
      // Add message listener (remove when not in use)
      ..messageManager.setAdvancedMsgListener(OnAdvancedMsgListener(
        onRecvMessageRevoked: recvMessageRevoked,
        onRecvC2CMessageReadReceipt: recvC2CReadReceipt,
        onRecvNewMessage: recvNewMessage,
        onRecvGroupMessageReadReceipt: recvGroupReadReceipt,
      ))

      // Set up message sending progress listener
      ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
        onProgress: progressCallback,
      ))

      // Set up friend relationship listener
      ..friendshipManager.setFriendshipListener(OnFriendshipListener(
        onBlacklistAdded: blacklistAdded,
        onBlacklistDeleted: blacklistDeleted,
        onFriendApplicationAccepted: friendApplicationAccepted,
        onFriendApplicationAdded: friendApplicationAdded,
        onFriendApplicationDeleted: friendApplicationDeleted,
        onFriendApplicationRejected: friendApplicationRejected,
        onFriendInfoChanged: friendInfoChanged,
        onFriendAdded: friendAdded,
        onFriendDeleted: friendDeleted,
      ))

      // Set up conversation listener
      ..conversationManager.setConversationListener(OnConversationListener(
        onConversationChanged: conversationChanged,
        onNewConversation: newConversation,
        onTotalUnreadMessageCountChanged: totalUnreadMsgCountChanged,
        // totalUnreadMsgCountChanged: (i) => unreadMsgCountCtrl.addSafely(i),
        onSyncServerFailed: () {},
        onSyncServerFinish: () {},
        onSyncServerStart: () {},
      ))

      // Set up group listener
      ..groupManager.setGroupListener(OnGroupListener(
        onGroupApplicationAccepted: groupApplicationAccepted,
        onGroupApplicationAdded: groupApplicationAdded,
        onGroupApplicationDeleted: groupApplicationDeleted,
        onGroupApplicationRejected: groupApplicationRejected,
        onGroupInfoChanged: groupInfoChanged,
        onGroupMemberAdded: groupMemberAdded,
        onGroupMemberDeleted: groupMemberDeleted,
        onGroupMemberInfoChanged: groupMemberInfoChanged,
        onJoinedGroupAdded: joinedGroupAdded,
        onJoinedGroupDeleted: joinedGroupDeleted,
      ));

    initializedSubject.sink.add(true);
  }

  Future login(String uid, String token) async {
    var user = await OpenIM.iMManager.login(uid: uid, token: token);
    return userInfo = user.obs;
  }

  Future logout() {
    return OpenIM.iMManager.logout();
  }
}
