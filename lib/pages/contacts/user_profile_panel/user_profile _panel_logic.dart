import 'dart:async';

import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_live/openim_live.dart';
import 'package:sprintf/sprintf.dart';

import '../../../core/controller/app_controller.dart';
import '../../../core/controller/im_controller.dart';
import '../../conversation/conversation_logic.dart';

class UserProfilePanelLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final conversationLogic = Get.find<ConversationLogic>();
  late Rx<UserFullInfo> userInfo;
  GroupMembersInfo? groupMembersInfo;
  GroupInfo? groupInfo;
  String? groupID;
  bool? offAllWhenDelFriend = false;
  final iHasMutePermissions = false.obs;
  final iAmOwner = false.obs;
  final mutedTime = "".obs;
  final onlineStatus = false.obs;
  final onlineStatusDesc = ''.obs;
  final groupUserNickname = "".obs;
  final joinGroupTime = 0.obs;
  final joinGroupMethod = ''.obs;
  final hasAdminPermission = false.obs;
  final notAllowLookGroupMemberProfiles = true.obs;
  final notAllowAddGroupMemberFriend = false.obs;
  final iHaveAdminOrOwnerPermission = false.obs;
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
    userInfo = (UserFullInfo()
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
          val?.remark = user.remark;
        });
      }
    });
    _memberInfoChangedSub = imLogic.memberInfoChangedSubject.listen((value) {
      if (value.userID == userInfo.value.userID) {
        if (null != value.muteEndTime) {
          _calMuteTime(value.muteEndTime!);
        }
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

  bool get isMyself => userInfo.value.userID == OpenIM.iMManager.userID;

  bool get isGroupMemberPage => null != groupID && groupID!.isNotEmpty;

  bool get isFriendship => userInfo.value.isFriendship == true;

  bool get isAllowAddFriend => userInfo.value.allowAddFriend == 1;

  bool get allowSendMsgNotFriend {
    final r = null == appLogic.clientConfigMap['allowSendMsgNotFriend'] ||
        appLogic.clientConfigMap['allowSendMsgNotFriend'] == '1';
    return r;
  }

  void _getUsersInfo() async {
    final userID = userInfo.value.userID!;
    final existUser = UserCacheManager().getUserInfo(userID);
    if (existUser != null) {
      userInfo.update((val) {
        val?.nickname = existUser.nickname;
        val?.faceURL = existUser.faceURL;
        val?.status = existUser.status;
        val?.level = existUser.level;
        val?.phoneNumber = existUser.phoneNumber;
        val?.areaCode = existUser.areaCode;
        val?.birth = existUser.birth;
        val?.email = existUser.email;
        val?.gender = existUser.gender;
        val?.mobile = existUser.mobile;
      });
    }

    final list = await OpenIM.iMManager.userManager.getUsersInfoWithCache(
      [userID],
    );
    final friendInfo = (await OpenIM.iMManager.friendshipManager.getFriendsInfo(
      userIDList: [userID],
      filterBlack: true,
    ))
        .firstOrNull;

    final blackList = await OpenIM.iMManager.friendshipManager.getBlacklist();

    final user = list.firstOrNull;
    final isFriendship = friendInfo != null;
    final isBlack = blackList.firstWhereOrNull((e) => e.userID == friendInfo?.userID) != null;

    if (user != null) {
      userInfo.update((val) {
        val?.nickname = user.nickname;
        val?.faceURL = user.faceURL;
        val?.remark = friendInfo?.nickname;
        val?.isBlacklist = isBlack;
        val?.isFriendship = isFriendship;
      });
    }

    final list2 = await Apis.getUserFullInfo(userIDList: [userID]);
    final fullInfo = list2?.firstOrNull;

    if (null != fullInfo) {
      UserCacheManager().addOrUpdateUserInfo(userID, fullInfo);

      userInfo.update((val) {
        val?.allowAddFriend = fullInfo.allowAddFriend;
        val?.status = fullInfo.status;
        val?.level = fullInfo.level;
        val?.phoneNumber = fullInfo.phoneNumber;
        val?.areaCode = fullInfo.areaCode;
        val?.birth = fullInfo.birth;
        val?.email = fullInfo.email;
        val?.gender = fullInfo.gender;
        val?.mobile = fullInfo.mobile;
      });
    }
  }

  _queryGroupInfo() async {
    if (isGroupMemberPage) {
      var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
        groupIDList: [groupID!],
      );
      groupInfo = list.firstOrNull;
      notAllowLookGroupMemberProfiles.value = groupInfo?.lookMemberInfo == 1;
      notAllowAddGroupMemberFriend.value = groupInfo?.applyMemberFriend == 1;
    }
  }

  _queryGroupMemberInfo() async {
    if (isGroupMemberPage) {
      final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: groupID!,
        userIDList: [userInfo.value.userID!, if (!isMyself) OpenIM.iMManager.userID],
      );
      final other = list.firstWhereOrNull((e) => e.userID == userInfo.value.userID);
      groupMembersInfo = other;
      groupUserNickname.value = other?.nickname ?? '';
      joinGroupTime.value = other?.joinTime ?? 0;

      _getJoinGroupMethod(other);

      hasAdminPermission.value = other?.roleLevel == GroupRoleLevel.admin;

      if (!isMyself) {
        var me = list.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID);
        iAmOwner.value = me?.roleLevel == GroupRoleLevel.owner;
        iHasMutePermissions.value = me?.roleLevel == GroupRoleLevel.owner ||
            (me?.roleLevel == GroupRoleLevel.admin && other?.roleLevel == GroupRoleLevel.member);
        iHaveAdminOrOwnerPermission.value =
            me?.roleLevel == GroupRoleLevel.owner || me?.roleLevel == GroupRoleLevel.admin;
      }

      if (null != other && null != other.muteEndTime && other.muteEndTime! > 0) {
        _calMuteTime(other.muteEndTime!);
      }
    }
  }

  _getJoinGroupMethod(GroupMembersInfo? other) async {
    if (other?.joinSource == 2) {
      if (other!.inviterUserID != null && other.inviterUserID != other.userID) {
        final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
          groupID: groupID!,
          userIDList: [other.inviterUserID!],
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

  _calMuteTime(int time) {
    var date = DateUtil.formatDateMs(time, format: IMUtils.getTimeFormat2());
    var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var diff = time - now;
    if (diff > 0) {
      mutedTime.value = date;
    } else {
      mutedTime.value = "";
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
      if (groupUserNickname.value.isEmpty) {
        return userInfo.value.nickname ??= "";
      }
      return groupUserNickname.value;
    }
    if (userInfo.value.remark != null && userInfo.value.remark!.isNotEmpty) {
      return '${userInfo.value.nickname}(${userInfo.value.remark})';
    }
    return userInfo.value.nickname ?? '';
  }

  void toggleAdmin() async {
    final hasPermission = !hasAdminPermission.value;
    final roleLevel = hasPermission ? GroupRoleLevel.admin : GroupRoleLevel.member;
    await LoadingView.singleton.wrap(
        asyncFunction: () => OpenIM.iMManager.groupManager.setGroupMemberRoleLevel(
              groupID: groupID!,
              userID: userInfo.value.userID!,
              roleLevel: roleLevel,
            ));

    groupMembersInfo?.roleLevel = roleLevel;
    hasAdminPermission.value = hasPermission;
    if (null != groupMembersInfo) {
      imLogic.memberInfoChangedSubject.add(groupMembersInfo!);
    }
    IMViews.showToast(StrRes.setSuccessfully);
  }

  void toChat() {
    conversationLogic.toChat(
      userID: userInfo.value.userID,
      nickname: userInfo.value.showName,
      faceURL: userInfo.value.faceURL,
    );
  }

  void toCall() {
    IMViews.openIMCallSheet(userInfo.value.showName, (index) {
      imLogic.call(
        callObj: CallObj.single,
        callType: index == 0 ? CallType.audio : CallType.video,
        inviteeUserIDList: [userInfo.value.userID!],
      );
    });
  }

  void setMute() => AppNavigator.startSetMuteForGroupMember(
        groupID: groupID!,
        userID: userInfo.value.userID!,
      );

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

  void viewDynamics() => {};
}

class UserCacheManager {
  static final UserCacheManager _instance = UserCacheManager._();
  UserCacheManager._();
  final Map<String, UserFullInfo> _userInfoMap = {};

  void addOrUpdateUserInfo(String userID, UserFullInfo userInfo) {
    _userInfoMap[userID] = userInfo;
  }

  UserFullInfo? getUserInfo(String userID) {
    return _userInfoMap[userID];
  }

  void removeUserInfo(String userID) {
    _userInfoMap.remove(userID);
  }

  factory UserCacheManager() {
    return _instance;
  }
}
