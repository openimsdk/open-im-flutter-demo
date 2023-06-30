import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../../core/controller/app_controller.dart';
import '../../../core/controller/im_controller.dart';
import '../../conversation/conversation_logic.dart';

class UserProfilePanelLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final conversationLogic = Get.find<ConversationLogic>();
  late Rx<UserInfo> userInfo;
  GroupMembersInfo? groupMembersInfo;
  GroupInfo? groupInfo;
  String? groupID;
  bool? offAllWhenDelFriend = false;
  final iAmOwner = false.obs;
  final mutedTime = "".obs;
  final onlineStatus = false.obs;
  final onlineStatusDesc = ''.obs;
  final groupUserNickname = "".obs;
  final joinGroupTime = 0.obs;
  final joinGroupMethod = ''.obs;
  final hasAdminPermission = false.obs;
  late StreamSubscription _friendAddedSub;
  late StreamSubscription _friendInfoChangedSub;
  late StreamSubscription _memberInfoChangedSub;

  @override
  void onClose() {
    _friendAddedSub.cancel();
    _friendInfoChangedSub.cancel();
    _memberInfoChangedSub.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    userInfo = (UserInfo()
          ..userID = Get.arguments['userID']
          ..nickname = Get.arguments['nickname']
          ..faceURL = Get.arguments['faceURL'])
        .obs;
    groupID = Get.arguments['groupID'];
    offAllWhenDelFriend = Get.arguments['offAllWhenDelFriend'];

    _friendAddedSub = imLogic.friendAddSubject.listen((user) {
      if (user.userID == userInfo.value.userID) {
        userInfo.update((val) {
          val?.isFriendship = true;
        });
      }
    });
    _friendInfoChangedSub = imLogic.friendInfoChangedSubject.listen((user) {
      if (user.userID == userInfo.value.userID) {
        userInfo.update((val) {
          val?.nickname = user.nickname;
          val?.gender = user.gender;
          val?.phoneNumber = user.phoneNumber;
          val?.birth = user.birth;
          val?.email = user.email;
          val?.remark = user.remark;
        });
      }
    });
    // 禁言时间被改变，或群成员资料改变
    _memberInfoChangedSub = imLogic.memberInfoChangedSubject.listen((value) {
      if (value.userID == userInfo.value.userID) {
        groupUserNickname.value = value.nickname ?? '';
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    _getUsersInfo();
    _queryGroupInfo();
    _queryGroupMemberInfo();
    // _queryUserOnlineStatus();
    super.onReady();
  }

  /// 是当前登录用户的资料页
  bool get isMyself => userInfo.value.userID == OpenIM.iMManager.userID;

  /// 当前是群成员资料页面
  bool get isGroupMemberPage => null != groupID && groupID!.isNotEmpty;

  bool get isFriendship => userInfo.value.isFriendship == true;

  void _getUsersInfo() async {
    final list = await OpenIM.iMManager.userManager.getUsersInfo(
      userIDList: [userInfo.value.userID!],
    );
    final user = list.firstOrNull;
    if (null != user) {
      userInfo.update((val) {
        val?.nickname = user.nickname;
        val?.faceURL = user.faceURL;
        val?.remark = user.remark;
        val?.gender = user.gender;
        val?.phoneNumber = user.phoneNumber;
        val?.birth = user.birth;
        val?.email = user.email;
        val?.isBlacklist = user.isBlacklist;
        val?.isFriendship = user.isFriendship;
      });
    }
  }

  _queryGroupInfo() async {
    if (isGroupMemberPage) {
      var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
        groupIDList: [groupID!],
      );
      groupInfo = list.firstOrNull;
    }
  }

  /// 查询我与当前页面用户的群成员信息
  _queryGroupMemberInfo() async {
    if (isGroupMemberPage) {
      final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: groupID!,
        userIDList: [
          userInfo.value.userID!,
          if (!isMyself) OpenIM.iMManager.userID
        ],
      );
      final other =
          list.firstWhereOrNull((e) => e.userID == userInfo.value.userID);
      groupMembersInfo = other;
      groupUserNickname.value = other?.nickname ?? '';
      joinGroupTime.value = other?.joinTime ?? 0;

      _getJoinGroupMethod(other);

      hasAdminPermission.value = other?.roleLevel == GroupRoleLevel.admin;

      // 是我查看其他人的资料
      if (!isMyself) {
        var me =
            list.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID);
        // 只有群主可以设置管理员
        iAmOwner.value = me?.roleLevel == GroupRoleLevel.owner;
      }
    }
  }

  _getJoinGroupMethod(GroupMembersInfo? other) async {
    // 入群方式 2：邀请加入 3：搜索加入 4：通过二维码加入
    if (other?.joinSource == 2) {
      if (other?.inviterUserID != null) {
        final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
          groupID: groupID!,
          userIDList: [other!.inviterUserID!],
        );
        var inviterUserInfo = list.firstOrNull;
        joinGroupMethod.value = sprintf(
          StrRes.byInviteJoinGroup,
          [inviterUserInfo?.nickname ?? ''],
        );
      }
    } else if (other?.joinSource == 3) {
      joinGroupMethod.value = StrRes.byIDJoinGroup;
    } else if (other?.joinSource == 4) {
      joinGroupMethod.value = StrRes.byQrcodeJoinGroup;
    }
  }

  String getShowName() {
    if (isGroupMemberPage) {
      if (isFriendship) {
        // if (userInfo.value.nickname != groupUserNickname.value) {
        //   return '${groupUserNickname.value}(${IMUtils.emptyStrToNull(userInfo.value.remark) ?? userInfo.value.nickname})';
        // } else {
        //   if (userInfo.value.remark != null &&
        //       userInfo.value.remark!.isNotEmpty) {
        //     return '${groupUserNickname.value}(${IMUtils.emptyStrToNull(userInfo.value.remark)})';
        //   }
        // }
        if (null != IMUtils.emptyStrToNull(userInfo.value.remark)) {
          return '${groupUserNickname.value}(${IMUtils.emptyStrToNull(userInfo.value.remark)})';
        }
      }
      return groupUserNickname.value;
    }
    if (userInfo.value.remark != null && userInfo.value.remark!.isNotEmpty) {
      return '${userInfo.value.nickname}(${userInfo.value.remark})';
    }
    return userInfo.value.nickname ?? '';
  }

  void toChat() {
    conversationLogic.toChat(
      userID: userInfo.value.userID,
      nickname: userInfo.value.getShowName(),
      faceURL: userInfo.value.faceURL,
    );
  }

  void copyID() {
    IMUtils.copy(text: userInfo.value.userID!);
  }

  void addFriend() => AppNavigator.startSendVerificationApplication(
        userID: userInfo.value.userID!,
      );

  void viewPersonalInfo() => AppNavigator.startPersonalInfo(
        userID: userInfo.value.userID!,
      );

  void friendSetup() => AppNavigator.startFriendSetup(
        userID: userInfo.value.userID!,
      );
}
