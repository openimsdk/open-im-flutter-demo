import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class ProcessFriendRequestsLogic extends GetxController {
  late FriendApplicationInfo applicationInfo;

  @override
  void onInit() {
    applicationInfo = Get.arguments['applicationInfo'];
    super.onInit();
  }

  /// 接受好友申请
  void acceptFriendApplication() async {
    LoadingView.singleton
        .wrap(
            asyncFunction: () => OpenIM.iMManager.friendshipManager
                .acceptFriendApplication(userID: applicationInfo.fromUserID!))
        .then(_addSuccessfully)
        .catchError((_) => IMViews.showToast(StrRes.addFailed));
  }

  /// 拒绝好友申请
  void refuseFriendApplication() async {
    LoadingView.singleton
        .wrap(
            asyncFunction: () => OpenIM.iMManager.friendshipManager
                .refuseFriendApplication(userID: applicationInfo.fromUserID!))
        .then(_rejectSuccessfully)
        .catchError((_) => IMViews.showToast(StrRes.rejectFailed));
  }

  _addSuccessfully(_) {
    IMViews.showToast(StrRes.addSuccessfully);
    Get.back(result: 1);
    return _;
  }

  _rejectSuccessfully(_) {
    IMViews.showToast(StrRes.rejectSuccessfully);
    Get.back(result: -1);
    return _;
  }
}
