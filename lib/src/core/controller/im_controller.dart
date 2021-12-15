import 'dart:io';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/common/config.dart';
import 'package:openim_enterprise_chat/src/core/callback/im_callback.dart';
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
      ipApi: Config.imApiUrl(),
      ipWs: Config.imWsUrl(),
      dbPath: '${(await getApplicationDocumentsDirectory()).path}/',
      listener: OnInitSDKListener(
        onConnecting: () {},
        onConnectFailed: (code, error) {},
        onConnectSuccess: () {},
        onKickedOffline: kickedOffline,
        onUserSigExpired: () {},
        onSelfInfoUpdated: (u) {
          userInfo.value = u;
        },
      ),
    );
    // Set listener
    OpenIM.iMManager
      // Add message listener (remove when not in use)
      ..messageManager.addAdvancedMsgListener(OnAdvancedMsgListener(
        onRecvMessageRevoked: recvMessageRevoked,
        onRecvC2CReadReceipt: recvC2CReadReceipt,
        onRecvNewMessage: recvNewMessage,
      ))

      // Set up message sending progress listener
      ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
        onProgress: progressCallback,
      ))

      // Set up friend relationship listener
      ..friendshipManager.setFriendshipListener(OnFriendshipListener(
        onBlackListAdd: blackListAdd,
        onBlackListDeleted: blackListDeleted,
        onFriendApplicationListAccept: friendApplicationListAccept,
        onFriendApplicationListAdded: friendApplicationListAdded,
        onFriendApplicationListDeleted: friendApplicationListDeleted,
        onFriendApplicationListReject: friendApplicationListReject,
        onFriendInfoChanged: friendInfoChanged,
        onFriendListAdded: friendListAdded,
        onFriendListDeleted: friendListDeleted,
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
        onApplicationProcessed: applicationProcessed,
        onGroupCreated: groupCreated,
        onGroupInfoChanged: groupInfoChanged,
        onMemberEnter: memberEnter,
        onMemberInvited: memberInvited,
        onMemberKicked: memberKicked,
        onMemberLeave: memberLeave,
        onReceiveJoinApplication: receiveJoinApplication,
      ));

    OpenIM.iMManager.enabledSDKLog(enabled: false);

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
