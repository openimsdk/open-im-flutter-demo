import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../group_requests_logic.dart';

class ProcessGroupRequestsLogic extends GetxController {
  final groupRequestsLogic = Get.find<GroupRequestsLogic>();
  late GroupApplicationInfo applicationInfo;

  @override
  void onInit() {
    applicationInfo = Get.arguments['applicationInfo'];
    super.onInit();
  }

  bool get isInvite => groupRequestsLogic.isInvite(applicationInfo);

  String get groupName => groupRequestsLogic.getGroupName(applicationInfo);

  String get inviterNickname => groupRequestsLogic.getInviterNickname(applicationInfo);

  GroupMembersInfo? getMemberInfo(inviterUserID) => groupRequestsLogic.getMemberInfo(inviterUserID);

  UserInfo? getUserInfo(inviterUserID) => groupRequestsLogic.getUserInfo(inviterUserID);

  String get sourceFrom {
    if (applicationInfo.joinSource == 2) {
      return '$inviterNickname${StrRes.byMemberInvite}';
    } else if (applicationInfo.joinSource == 4) {
      return StrRes.byScanQrcode;
    }
    return StrRes.bySearch;
  }

  void approve() {
    LoadingView.singleton
        .wrap(
            asyncFunction: () => OpenIM.iMManager.groupManager.acceptGroupApplication(
                  groupID: applicationInfo.groupID!,
                  userID: applicationInfo.userID!,
                  handleMsg: "reason",
                ))
        .then((value) => Get.back(result: 1))
        .catchError(_parse);
  }

  void reject() {
    LoadingView.singleton
        .wrap(
            asyncFunction: () => OpenIM.iMManager.groupManager.refuseGroupApplication(
                  groupID: applicationInfo.groupID!,
                  userID: applicationInfo.userID!,
                  handleMsg: "reason",
                ))
        .then((value) => Get.back(result: -1))
        .catchError(_parse)
        .catchError((_) => IMViews.showToast(StrRes.rejectFailed));
  }

  _parse(e) {
    if (e is PlatformException) {
      if (e.code == '${SDKErrorCode.groupApplicationHasBeenProcessed}') {
        IMViews.showToast(StrRes.groupRequestHandled);
        return;
      }
    }
    throw e;
  }
}
